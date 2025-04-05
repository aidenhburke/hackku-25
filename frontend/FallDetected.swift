import SwiftUI
import UserNotifications

struct FallDetectionView: View {
    @State private var timeRemaining = 30
    @State private var timer: Timer? = nil
    @State private var timerExpired = false
    @EnvironmentObject var motionManager: MotionManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("FALL DETECTED")
                .font(.system(size: 45))
                .bold()
                .foregroundColor(Color(hex: 0xEE3233))
                .padding(.top, 40)

            Spacer()

            if timerExpired {
                Text("Emergency Contacts Notified")
                    .font(.system(size: 35))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: 0xEE3233))
                    .padding(.top, 0)
            } else {
                Text("\(timeRemaining)")
                    .font(.system(size: 45))
                    .foregroundColor(Color(hex: 0x66A7C5))
                    .padding(.top, 0)
            }

            Spacer()

            VStack(spacing: 20) {
                Button(action: {
                    motionManager.lastFallDate = Date()
                    motionManager.fallDetected = false
                    motionManager.startMonitoring()
                    invalidateTimer()
                    dismiss()
                }) {
                    Text("Fall")
                        .font(.system(size: 70))
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .background(Color(hex: 0xEE3233))
                        .foregroundColor(Color(hex: 0xF0ECEB))
                        .cornerRadius(20)
                        .padding(.horizontal, 25)
                }

                Button(action: {
                    motionManager.fallDetected = false
                    motionManager.startMonitoring()
                    invalidateTimer()
                    dismiss()
                }) {
                    Text("Not a Fall")
                        .font(.system(size: 70))
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .background(Color(hex: 0x66A7C5))
                        .foregroundColor(Color(hex: 0xF0ECEB))
                        .cornerRadius(20)
                        .padding(.horizontal, 25)
                }
            }
            .padding(.bottom, 40)
        }
        .padding()
        .background(Color(hex: 0xCEEBFB))
        .onAppear {
            startTimer()
            motionManager.stopMonitoring()
        }
        .onDisappear {
            motionManager.startMonitoring()
        }
    }

    private func startTimer() {
        timerExpired = false

        if let startedDate = motionManager.timerStartedDate {
            let elapsed = Int(Date().timeIntervalSince(startedDate))
            timeRemaining = max(30 - elapsed, 0)
        } else {
            timeRemaining = 30
            motionManager.timerStartedDate = Date()
        }

        if timeRemaining <= 0 {
            handleTimerExpiration()
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                handleTimerExpiration()
            }
        }
    }

    private func handleTimerExpiration() {
        timerExpired = true
        motionManager.lastFallDate = Date()
        invalidateTimer()
        motionManager.stopMonitoring()
        sendTimeoutNotification()
        dismiss()
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func sendTimeoutNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Time Expired"
        content.body = "Contacting emergency contacts now."
        content.sound = .default
        content.categoryIdentifier = "FALL_TIMEOUT"

        let request = UNNotificationRequest(identifier: "FallTimeout", content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to send timeout notification: \(error)")
            }
        }
    }
}

#Preview {
    FallDetectionView()
        .environmentObject(MotionManager())
}
