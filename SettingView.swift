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
    @State private var locationTracking = false
    @State private var locationStatus: CLAuthorizationStatus = .notDetermined
    @State private var alertVibration = true
    @State private var notificationsEnabled = false
    @State private var contactsAccessGranted = false
    @State private var systemCanVibrate = true
    @State private var hasRequestedPermissions = false

    @StateObject private var locationManager = LocationManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Settings")
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Circle()
                        .fill(notificationsEnabled ? Color.green : Color.red)
                        .frame(width: 12, height: 12)
                    Text("Notifications")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Button("Manage") {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                    .foregroundColor(.purple)
                }

                VStack(alignment: .leading) {
                    HStack {
                        Circle()
                            .fill(locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse ? Color.green : Color.orange)
                            .frame(width: 12, height: 12)
                        Text("Location Access")
                            .foregroundColor(.white)
                            .font(.headline)
                        Spacer()
                        Button("Manage") {
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL)
                            }
                        }
                        .foregroundColor(.purple)
                    }
                    if locationStatus != .authorizedAlways && locationStatus != .authorizedWhenInUse {
                        Text("Limited or no access – open Settings to allow full location access.")
                            .foregroundColor(.gray)
                            .font(.caption)
                            .padding(.top, 2)
                    }
                }

                HStack {
                    Circle()
                        .fill(systemCanVibrate ? Color.green : Color.red)
                        .frame(width: 12, height: 12)
                    Text("Alert Vibration")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Button("Manage") {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                    .foregroundColor(.purple)
                }

                HStack {
                    Circle()
                        .fill(contactsAccessGranted ? Color.green : Color.red)
                        .frame(width: 12, height: 12)
                    Text("Contacts Access")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Button("Manage") {
                        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(settingsURL)
                        }
                    }
                    .foregroundColor(.purple)
                }
            }
            .padding()
            .background(Color(.systemGray5).opacity(0.2))
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .onAppear {
            if !hasRequestedPermissions {
                hasRequestedPermissions = true

                // Request Notification Permission
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    DispatchQueue.main.async {
                        self.notificationsEnabled = granted
                    }
                }

                // Request Location Permission
                locationManager.requestPermission()

                // Request Contacts Permission
                CNContactStore().requestAccess(for: .contacts) { granted, error in
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

            CNContactStore().requestAccess(for: .contacts) { granted, _ in
                DispatchQueue.main.async {
                    self.contactsAccessGranted = granted
                }
            }

            self.systemCanVibrate = true
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}
