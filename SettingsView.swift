import SwiftUI
import CoreLocation
import UserNotifications
import AVFoundation
import Contacts

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func authorizationStatus() -> CLAuthorizationStatus {
        return manager.authorizationStatus
    }
}

struct SettingsView: View {
    @EnvironmentObject var motionManager: MotionManager
    @State private var locationTracking = false
    @State private var locationStatus: CLAuthorizationStatus = .notDetermined
    @State private var alertVibration = true
    @State private var notificationsEnabled = false
    @State private var contactsAccessGranted = false
    @State private var systemCanVibrate = true
    @State private var hasRequestedPermissions = false

    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Settings")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 24) {
                    // Notifications
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Circle()
                                .fill(notificationsEnabled ? Color.green : Color.red)
                                .frame(width: 18, height: 18)
                            Text("Notifications")
                                .foregroundColor(.white)
                                .font(.title2)
                            Spacer()
                            Button("Manage") {
                                openAppSettings()
                            }
                            .foregroundColor(.purple)
                        }
                        Text("We use notifications to alert you of important safety messages and status updates.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                    .padding()
                    .background(Color(.systemGray5).opacity(0.3))
                    .cornerRadius(16)

                    // Location
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Circle()
                                .fill(locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse ? Color.green : Color.orange)
                                .frame(width: 18, height: 18)
                            Text("Location Access")
                                .foregroundColor(.white)
                                .font(.title2)
                            Spacer()
                            Button("Manage") {
                                openAppSettings()
                            }
                            .foregroundColor(.purple)
                        }
                        Text("Location data helps us detect falls and provide accurate emergency location support.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.trailing)
                        if locationStatus != .authorizedAlways && locationStatus != .authorizedWhenInUse {
                            Text("Limited or no access – open Settings to allow full location access.")
                                .foregroundColor(.gray)
                                .font(.body)
                                .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray5).opacity(0.3))
                    .cornerRadius(16)

                    // Alert Vibration
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Circle()
                                .fill(systemCanVibrate ? Color.green : Color.red)
                                .frame(width: 18, height: 18)
                            Text("Alert Vibration")
                                .foregroundColor(.white)
                                .font(.title2)
                            Spacer()
                            Button("Manage") {
                                openAppSettings()
                            }
                            .foregroundColor(.purple)
                        }
                        Text("Vibrations are used to ensure that critical alerts reach you even when sound is off.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                    .padding()
                    .background(Color(.systemGray5).opacity(0.3))
                    .cornerRadius(16)

                    // Contacts Access
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Circle()
                                .fill(contactsAccessGranted ? Color.green : Color.red)
                                .frame(width: 18, height: 18)
                            Text("Contacts Access")
                                .foregroundColor(.white)
                                .font(.title2)
                            Spacer()
                            Button("Manage") {
                                openAppSettings()
                            }
                            .foregroundColor(.purple)
                        }
                        Text("We use your contacts to notify emergency contacts when a fall or alert is detected.")
                            .font(.body)
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                    .padding()
                    .background(Color(.systemGray5).opacity(0.3))
                    .cornerRadius(16)
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .onAppear {
            if !hasRequestedPermissions {
                hasRequestedPermissions = true

                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    DispatchQueue.main.async {
                        self.notificationsEnabled = granted
                    }
                }

                locationManager.requestPermission()

                CNContactStore().requestAccess(for: .contacts) { granted, _ in
                    DispatchQueue.main.async {
                        self.contactsAccessGranted = granted
                    }
                }
            }

            UNUserNotificationCenter.current().getNotificationSettings { settings in
                DispatchQueue.main.async {
                    self.notificationsEnabled = settings.authorizationStatus == .authorized || settings.authorizationStatus == .provisional
                }
            }

            let status = locationManager.authorizationStatus()
            self.locationStatus = status
            self.locationTracking = status == .authorizedWhenInUse || status == .authorizedAlways

            self.systemCanVibrate = true
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }

    func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsURL)
        }
    }
}
