import SwiftUI

struct RootView: View {
    @EnvironmentObject var motionManager: MotionManager
    @StateObject private var contactStore = ContactStore()
    
    var body: some View {
        ZStack {
            if motionManager.fallDetected {
                FallDetectionView(contactStore: contactStore)
            } else {
                MainTabView()
            }
        }
        .onAppear {
            motionManager.startMonitoring()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("FallNotificationTapped"))) { _ in
            motionManager.fallDetected = true
        }
    }
}
