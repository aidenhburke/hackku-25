import SwiftUI

struct FallDetectionView: View {
    @State private var timeRemaining = 30 // Timer set for 30 seconds
    @State private var timer: Timer? = nil
    @State private var timerExpired = false
    @EnvironmentObject var motionManager: MotionManager

    var body: some View {
        VStack(spacing: 20) {
            Text("FALL DETECTED")
                .font(.system(size: 45))
                .bold()
                .foregroundColor(Color(hex: 0x66A7C5))
                .padding(.top, 40)

            Spacer()

            if timerExpired {
                Text("Emergency Contacts Notified")
                    .font(.system(size: 35))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: 0x66A7C5))
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
                    print("User confirmed a real fall")
                    motionManager.fallDetected = false
                    motionManager.startMonitoring()
                    invalidateTimer()
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
                    print("User confirmed no fall")
                    motionManager.fallDetected = false
                    motionManager.startMonitoring()
                    invalidateTimer()
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
        .background((Color(hex: 0xCEEBFB)))
        .onAppear {
            startTimer()
        }
        .onDisappear {
            motionManager.startMonitoring()
            invalidateTimer()
        }
    }

    // Start the timer
    private func startTimer() {
        timerExpired = false
        timeRemaining = 30

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerExpired = true
                invalidateTimer()
                print("Timer expired. Fall detection process needs review.")
                // Optionally, stop monitoring after the timer expires
                motionManager.stopMonitoring()
            }
        }
    }

    // Invalidate the timer when done
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    FallDetectionView()
    .environmentObject(MotionManager())
}
