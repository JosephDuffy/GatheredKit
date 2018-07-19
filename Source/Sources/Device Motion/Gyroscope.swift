import Foundation
import CoreMotion

public final class Gyroscope: BaseSource, CustomisableUpdateIntervalControllable, ValuesProvider {

    public static var defaultUpdateInterval: TimeInterval = 1

    public static var availability: SourceAvailability {
        return isAvailable ? .available : .unavailable
    }

    public static var isAvailable: Bool {
        return CMMotionManager().isGyroAvailable
    }

    public private(set) var rotationRate: RotationRateValue

    public private(set) var rawRotationRate: RotationRateValue

    public var allValues: [AnyValue] {
        return [
            rotationRate.asAny(),
            rawRotationRate.asAny(),
        ]
    }

    public private(set) var updateInterval: TimeInterval?

    private var motionManager: CMMotionManager?

    public override init() {
        let date = Date()
        rotationRate = RotationRateValue(name: "Rotation Rate (Calibrated)", date: date)
        rawRotationRate = RotationRateValue(name: "Rotation Rate (Raw)", date: date)
    }

    deinit {
        stopUpdating()
    }

    public func stopUpdating() {
        motionManager?.stopDeviceMotionUpdates()
        motionManager?.stopGyroUpdates()
        motionManager = nil
        updateInterval = nil
    }

    public func startUpdating(every updateInterval: TimeInterval) {
        if isUpdating {
            stopUpdating()
        }

        self.updateInterval = updateInterval
        let motionManager = CMMotionManager()
        self.motionManager = motionManager
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.gyroUpdateInterval = updateInterval

        let calibratedHandler: CMDeviceMotionHandler = { [weak self] (_ data: CMDeviceMotion?, error: Error?) in
            guard let `self` = self else { return }
            guard self.isUpdating else { return }

            let date: Date

            if let timestamp = data?.timestamp {
                date = Date(timeIntervalSince1970: timestamp)
            } else {
                date = Date()
            }

            self.rawRotationRate.update(backingValue: data?.rotationRate, date: date)
            self.notifyListenersPropertyValuesUpdated()
        }

        let rawHandler: CMGyroHandler = { [weak self] (_ data: CMGyroData?, error: Error?) in
            guard let `self` = self else { return }
            guard self.isUpdating else { return }

            let date: Date

            if let timestamp = data?.timestamp {
                date = Date(timeIntervalSince1970: timestamp)
            } else {
                date = Date()
            }

            self.rotationRate.update(backingValue: data?.rotationRate, date: date)
            self.notifyListenersPropertyValuesUpdated()
        }

        let operationQueue = OperationQueue()
        motionManager.startDeviceMotionUpdates(to: operationQueue, withHandler: calibratedHandler)
        motionManager.startGyroUpdates(to: operationQueue, withHandler: rawHandler)
    }
}
