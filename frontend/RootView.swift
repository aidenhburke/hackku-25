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
    }
}	

#Preview {
    RootView()
    .environmentObject(MotionManager())
}
