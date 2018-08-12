import Foundation
import CoreMotion

public final class Accelerometer: BaseSource, Source, CustomisableUpdateIntervalControllable, ValuesProvider {

    public static var defaultUpdateInterval: TimeInterval = 1

    public static var availability: SourceAvailability {
        return isAvailable ? .available : .unavailable
    }

    public static var isAvailable: Bool {
        return CMMotionManager().isAccelerometerAvailable
    }

    public static let name = "Accelerometer"

    public private(set) var totalAcceletation: AccelerationValue

    public private(set) var gravitationalAcceletation: AccelerationValue

    public private(set) var userAcceleration: AccelerationValue

    public private(set) var rawAcceleration: AccelerationValue

    public var allValues: [Value] {
        return [
            totalAcceletation,
            gravitationalAcceletation,
            userAcceleration,
            rawAcceleration,
        ]
    }

    public private(set) var updateInterval: TimeInterval?

    private var motionManager: CMMotionManager?

    public override init() {
        let date = Date()
        totalAcceletation = AccelerationValue(name: "Gravitational Acceleration", date: date)
        gravitationalAcceletation = AccelerationValue(name: "Gravitational Acceleration", date: date)
        userAcceleration = AccelerationValue(name: "User Acceleration", date: date)
        rawAcceleration = AccelerationValue(name: "Raw Acceleration", date: date)
    }

    deinit {
        stopUpdating()
    }

    public func stopUpdating() {
        motionManager?.stopDeviceMotionUpdates()
        motionManager?.stopAccelerometerUpdates()
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
        motionManager.accelerometerUpdateInterval = updateInterval

        let deviceMotionHandler: CMDeviceMotionHandler = { [weak self] (_ data: CMDeviceMotion?, error: Error?) in
            guard let `self` = self else { return }
            guard self.isUpdating else { return }

            let date: Date

            if let timestamp = data?.timestamp {
                date = Date(timeIntervalSince1970: timestamp)
            } else {
                date = Date()
            }

            let total: CMAcceleration?

            if let gravity = data?.gravity, let userAcceleration = data?.userAcceleration {
                total = gravity + userAcceleration
            } else {
                total = nil
            }

            self.totalAcceletation.update(backingValue: total, date: date)
            self.gravitationalAcceletation.update(backingValue: data?.gravity, date: date)
            self.userAcceleration.update(backingValue: data?.userAcceleration, date: date)
            self.notifyListenersPropertyValuesUpdated()
        }

        let rawHandler: CMAccelerometerHandler = { [weak self] (_ data: CMAccelerometerData?, error: Error?) in
            guard let `self` = self else { return }
            guard self.isUpdating else { return }

            let date: Date

            if let timestamp = data?.timestamp {
                date = Date(timeIntervalSince1970: timestamp)
            } else {
                date = Date()
            }

            self.rawAcceleration.update(backingValue: data?.acceleration, date: date)
            self.notifyListenersPropertyValuesUpdated()
        }

        let operationQueue = OperationQueue()
        motionManager.startDeviceMotionUpdates(to: operationQueue, withHandler: deviceMotionHandler)
        motionManager.startAccelerometerUpdates(to: operationQueue, withHandler: rawHandler)
    }
}

private extension CMAcceleration {

    static func + (lhs: CMAcceleration, rhs: CMAcceleration) -> CMAcceleration {
        return CMAcceleration(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

}
