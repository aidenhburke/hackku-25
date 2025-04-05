import SwiftUI

@main
struct SafeStepApp: App {
    @StateObject var motionManager = MotionManager()
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = false  // Use AppStorage to persist the flag

    var body: some Scene {
        WindowGroup {
            if isFirstTimeUser {
                FirstTimeUserView()
                    .onDisappear {
                        // Set isFirstTimeUser to false when the user finishes with the FirstTimeUserView
                        isFirstTimeUser = false
                    }
            } else {
                RootView()
                    .environmentObject(motionManager)
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
