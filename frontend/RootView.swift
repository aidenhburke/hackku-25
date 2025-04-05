import SwiftUI

struct RootView: View {
    @EnvironmentObject var motionManager: MotionManager

    var body: some View {
        ZStack {
            if motionManager.fallDetected {
                FallDetectionView()
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

#Preview {
    RootView()
        .environmentObject(MotionManager())
}
