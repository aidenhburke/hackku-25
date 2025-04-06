import SwiftUI
import UserNotifications
import CoreLocation

struct FallEvent: Codable {
    var username: String
    var location: String
    var contacts: [String]
}

func sendFallAlert(name: String, location: String, numbers: [String]) {
    guard let url = URL(string: "https://fall-detection-backend-marktmaloney-mark-maloneys-projects.vercel.app/api/send_sms") else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let payload: [String: Any] = [
        "name": name,
        "location": location,
        "numbers": numbers
    ]

    do {
        let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
        request.httpBody = jsonData
    } catch {
        print("Failed to encode JSON: \(error)")
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error sending SMS: \(error)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("Failed to send SMS: Invalid response")
            return
        }

        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("Response from server: \(responseString)")
        }
    }.resume()
}

struct FallDetectionView: View {
    @State private var timeRemaining = 30
    @State private var timer: Timer? = nil
    @State private var timerExpired = false
    @EnvironmentObject var motionManager: MotionManager
    @Environment(\.dismiss) private var dismiss
    @AppStorage("username") private var username: String = ""
    @ObservedObject var contactStore: ContactStore
    @StateObject private var locationManager = CurrentLocationManager()

    var body: some View {
        VStack(spacing: 20) {
            Text("FALL DETECTED")
                .font(.system(size: 45))
                .bold()
                .foregroundColor(Color(hex: 0xEE3233))
                .padding(.top, 40)

            Spacer()

            if timerExpired {
                Text("Emergency Contacts Notified")
                    .font(.system(size: 35))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: 0xEE3233))
                    .padding(.top, 0)
            } else {
                Text("\(timeRemaining)")
                    .font(.system(size: 45))
                    .foregroundColor(Color(hex: 0x66A7C5))
                    .padding(.top, 0)
            }

            Spacer()

            if !timerExpired {
                VStack(spacing: 20) {
                    Button(action: {
                        motionManager.lastFallDate = Date()
                        logFallEvent()
                        motionManager.fallDetected = false
                        motionManager.startMonitoring()
                        invalidateTimer()
                        dismiss()
                    }) {
                        Text("Fall")
                            .font(.system(size: 70))
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color(hex: 0xEE3233))
                            .foregroundColor(Color(hex: 0xF0ECEB))
                            .cornerRadius(20)
                            .padding(.horizontal, 25)
                    }

                    Button(action: {
                        motionManager.fallDetected = false
                        motionManager.startMonitoring()
                        invalidateTimer()
                        dismiss()
                    }) {
                        Text("Not a Fall")
                            .font(.system(size: 70))
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 200)
                            .background(Color(hex: 0x66A7C5))
                            .foregroundColor(Color(hex: 0xF0ECEB))
                            .cornerRadius(20)
                            .padding(.horizontal, 25)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .padding()
        .background((Color(hex: 0xCEEBFB)))
        .onAppear {
            startTimer()
            motionManager.stopMonitoring()
            locationManager.requestLocation()
        }
        .onDisappear {
            motionManager.startMonitoring()
        }
    }

    private func startTimer() {
        timerExpired = false

        if let startedDate = motionManager.timerStartedDate {
            let elapsed = Int(Date().timeIntervalSince(startedDate))
            timeRemaining = max(30 - elapsed, 0)
        } else {
            timeRemaining = 30
            motionManager.timerStartedDate = Date()
        }

        if timeRemaining <= 0 {
            handleTimerExpiration()
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                handleTimerExpiration()
            }
        }
    }

    private func handleTimerExpiration() {
        timerExpired = true
        motionManager.lastFallDate = Date()
        logFallEvent()
        invalidateTimer()
        motionManager.fallDetected = false
        motionManager.startMonitoring()
        sendTimeoutNotification()
        dismiss()
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func logFallEvent() {
        let location = locationManager.currentLocation ?? "Unknown Location"
        let emergencyContacts = contactStore.emails

        let fallEvent = FallEvent(username: username, location: location, contacts: emergencyContacts)

        print(fallEvent)

        sendFallAlert(name: fallEvent.username, location: fallEvent.location, numbers: fallEvent.contacts)
    }

    private func sendTimeoutNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time Expired"
        content.body = "Contacting emergency contacts now."
        content.sound = .default
        content.categoryIdentifier = "FALL_TIMEOUT"

        let request = UNNotificationRequest(identifier: "FallTimeout", content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send timeout notification: \(error)")
            }
        }
    }
}

class CurrentLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    @Published var currentLocation: String?

    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let locationString = "\(location.coordinate.latitude), \(location.coordinate.longitude)"
            currentLocation = locationString
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error)")
        currentLocation = "Location unavailable"
    }
}
