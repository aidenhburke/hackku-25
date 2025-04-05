import SwiftUI

@main
struct SafeStepApp: App {
    @StateObject var motionManager = MotionManager()
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = true  // Use AppStorage to persist the flag
    @State var isLoggedIn = false

    var body: some Scene {
        WindowGroup {
            if isFirstTimeUser {
                FirstTimeUserView(isLoggedIn: $isLoggedIn)
                    .onAppear {
                        // Print the values when the view appears
                        print("isFirstTimeUser: \(isFirstTimeUser)")
                        print("isLoggedIn: \(isLoggedIn)")
                    }
            }
            else if isLoggedIn{
                RootView()
                .environmentObject(motionManager)
                .onAppear {
                    // Print the values when the view appears
                    print("isFirstTimeUser: \(isFirstTimeUser)")
                    print("isLoggedIn: \(isLoggedIn)")
                }
            }
            else {
                RootView()
                .environmentObject(motionManager)
                .onAppear {
                    // Print the values when the view appears
                    print("isFirstTimeUser: \(isFirstTimeUser)")
                    print("isLoggedIn: \(isLoggedIn)")
                }
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
