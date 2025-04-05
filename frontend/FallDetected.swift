import SwiftUI

struct FallEvent: Codable {
    var date: String
    var description: String
}

func sendFallEvent(fallEvent: FallEvent) {
    guard let url = URL(string: "https://fall-detection-backend-marktmaloney-mark-maloneys-projects.vercel.app/api/fall_events") else { return }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(fallEvent)
        request.httpBody = jsonData
    } catch {
        print("Failed to encode fall event: \(error)")
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }

        guard let data = data else {
            print("No data received.")
            return
        }

        if let responseString = String(data: data, encoding: .utf8) {
            print("Response: \(responseString)")
        }
    }.resume()
}

struct FallDetectionView: View {
    @State private var timeRemaining = 30 // Timer set for 30 seconds
    @State private var timer: Timer? = nil
    @State private var timerExpired = false
    @EnvironmentObject var motionManager: MotionManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("FALL DETECTED")
                .font(.system(size: 45))
                .bold()
                .foregroundColor(Color(hex: 0x66A7C5))
                .padding(.top, 40)

            Spacer()

            if timerExpired {
                Text("Emergency Contacts Notified")
                    .font(.system(size: 35))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: 0x66A7C5))
                    .padding(.top, 0)
            } else {
                Text("\(timeRemaining)")
                    .font(.system(size: 45))
                    .foregroundColor(Color(hex: 0x66A7C5))
                    .padding(.top, 0)
            }

            Spacer()

            VStack(spacing: 20) {
                Button(action: {
                    print("User confirmed a real fall")
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
                    print("User confirmed no fall")
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
        .padding()
        .background((Color(hex: 0xCEEBFB)))
        .onAppear {
            startTimer()
            motionManager.stopMonitoring()
        }
        .onDisappear {
            motionManager.startMonitoring()
            invalidateTimer()
        }
    }

    private func startTimer() {
        timerExpired = false
        timeRemaining = 30

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerExpired = true
                invalidateTimer()
                print("Timer expired. Fall detection process needs review.")
                motionManager.stopMonitoring()
                logFallEvent()
                dismiss()
            }
        }
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func logFallEvent() {
        let fallEvent = FallEvent(date: "\(Date())", description: "Fall detected by app")
        sendFallEvent(fallEvent: fallEvent)
    }
}

#Preview {
    FallDetectionView()
        .environmentObject(MotionManager())
}

