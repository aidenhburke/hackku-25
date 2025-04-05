import Foundation
import CoreMotion
import Combine
import UserNotifications

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    private var hasSentFallNotification = false

    @Published var fallDetected = false
    @Published var accelerometerAvailable = true
    @Published var lastFallDate: Date? = nil
    private let accelerationThreshold = 25.0

    func startMonitoring() {
        hasSentFallNotification = false

        guard motionManager.isAccelerometerAvailable else {
            self.accelerometerAvailable = false
            return
        }

        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates()

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let data = self.motionManager.accelerometerData {
                let x = data.acceleration.x * 9.8
                let y = data.acceleration.y * 9.8
                let z = data.acceleration.z * 9.8

                let totalAcceleration = sqrt(x * x + y * y + z * z)
                if totalAcceleration > 5 {
                    print(totalAcceleration)
                }

                if totalAcceleration > self.accelerationThreshold {
                    DispatchQueue.main.async {
                        if !self.fallDetected {
                            self.fallDetected = true
                            self.lastFallDate = Date()
                            self.stopMonitoring()
                            if !self.hasSentFallNotification {
                                self.hasSentFallNotification = true
                                self.sendFallDetectedNotification()
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.fallDetected = false
                    }
                }
            }
        }
    }

    func stopMonitoring() {
        motionManager.stopAccelerometerUpdates()
        timer?.invalidate()
        timer = nil
    }

    private func sendFallDetectedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Fall Detected"
        content.body = "Tap to open SafeStep and confirm your status."
        content.sound = .default
        content.categoryIdentifier = "FALL_DETECTED"

        let request = UNNotificationRequest(
            identifier: "MotionFallDetectedNotification",
            content: content,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule motion-based notification: \(error)")
            }
        }
    }
}
