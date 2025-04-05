import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Set the notification delegate
        UNUserNotificationCenter.current().delegate = self

        // Define the notification category for fall alerts
        let fallCategory = UNNotificationCategory(
            identifier: "FALL_DETECTED",
            actions: [],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        UNUserNotificationCenter.current().setNotificationCategories([fallCategory])

        return true
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Check if the tapped notification was a fall alert
        if response.notification.request.content.categoryIdentifier == "FALL_DETECTED" {
            NotificationCenter.default.post(name: Notification.Name("FallNotificationTapped"), object: nil)
        }
        completionHandler()
    }
}
