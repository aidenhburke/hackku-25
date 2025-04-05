//
//  SafeStepApp.swift
//  SafeStep
//
//  Created by Ty Farrington on 4/4/25.
//

import SwiftUI
import UserNotifications

@main
struct SafeStepApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var motionManager = MotionManager()
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = false
    @State var isLoggedIn = false

    init() {
        requestNotificationPermission()
    }

    var body: some Scene {
        WindowGroup {
            if isFirstTimeUser {
                FirstTimeUserView(isLoggedIn: $isLoggedIn)
            } else if isLoggedIn {
                RootView()
                    .environmentObject(motionManager)
            } else {
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
