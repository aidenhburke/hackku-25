import SwiftUI
import UserNotifications

@main
struct SafeStepApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var motionManager = MotionManager()
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = true
    @AppStorage("username") var storedUsername: String = ""
    
    var body: some Scene {
        WindowGroup {
            // Determine which view to show based on login and first-time user status
            if isFirstTimeUser {
                FirstTimeUserView()
                    .onChange(of: storedUsername) { _ in
                        // Update first-time user status after login
                        if !storedUsername.isEmpty {
                            isFirstTimeUser = false
                        }
                    }
            } else if !storedUsername.isEmpty {
                RootView()
                    .environmentObject(motionManager)
            }
        }
    }
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            } else {
                print("Notification permission granted: \(granted)")
            }
        }
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}
