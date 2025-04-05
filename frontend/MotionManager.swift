import Foundation
import CoreMotion
import Combine

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private var timer: Timer?
    
    // Published property to notify SwiftUI views
    @Published var fallDetected = false
    @Published var accelerometerAvailable = true
    private let accelerationThreshold = 2.5  // Change as needed

    func startMonitoring() {
        // Check if the accelerometer is available
        guard motionManager.isAccelerometerAvailable else {
            self.accelerometerAvailable = false
            print("Accelerometer not available")
            return
        }

        motionManager.accelerometerUpdateInterval = 0.1  // Set the interval for sensor data updates

        // Start receiving accelerometer updates
        motionManager.startAccelerometerUpdates()

        // Timer to check accelerometer data
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if let data = self.motionManager.accelerometerData {
                let x = data.acceleration.x
                let y = data.acceleration.y
                let z = data.acceleration.z

                // Calculate the total acceleration
                let totalAcceleration = sqrt(x * x + y * y + z * z)

                // If the acceleration exceeds the threshold, it's considered a fall
                if totalAcceleration > self.accelerationThreshold {
                    DispatchQueue.main.async {
                        self.fallDetected = true
                        self.stopMonitoring()
                        print("💥 Fall detected! Acceleration: \(totalAcceleration)")
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
        // Stop receiving accelerometer updates and invalidate the timer
        motionManager.stopAccelerometerUpdates()
        timer?.invalidate()
        timer = nil
    }
}
