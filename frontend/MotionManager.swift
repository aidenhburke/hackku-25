import Foundation
import CoreMotion
import Combine
import UserNotifications
import UIKit
import CoreLocation

class MotionManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let motionManager = CMMotionManager()
    private var monitorTimer: Timer?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var hasSentFallNotification = false
    private let locationManager = CLLocationManager()

    @Published var fallDetected = false
    @Published var accelerometerAvailable = true
    @Published var lastFallDate: Date? = nil
    @Published var timerStartedDate: Date? = nil
    private let accelerationThreshold = 25.0

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func startMonitoring() {
        hasSentFallNotification = false

        guard motionManager.isAccelerometerAvailable else {
            self.accelerometerAvailable = false
            return
        }

        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates()

        monitorTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
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
                            self.timerStartedDate = Date()
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

        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "MotionMonitoring") {
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
    }

    func stopMonitoring() {
        motionManager.stopAccelerometerUpdates()
        monitorTimer?.invalidate()
        monitorTimer = nil
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
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

    func setupLocationBackgroundKeepAlive() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // No-op: only used to keep app alive in background
    }
}

