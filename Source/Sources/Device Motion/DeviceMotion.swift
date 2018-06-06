import Foundation
import CoreMotion

public final class DeviceMotion: BaseSource, CustomisableUpdateIntervalSource {

    public static var defaultUpdateInterval: TimeInterval = 0.1

    public static var availability: SourceAvailability {
        return isAvailable ? .available : .unavailable
    }

    public static var isAvailable: Bool {
        return CMMotionManager().isDeviceMotionAvailable && CMMotionManager().isAccelerometerAvailable
    }

    private var latestData: CMDeviceMotion?

    public var attitude: GenericValue<CMAttitude, None>? {
        guard let data = latestData else { return nil }
        let date = Date(timeIntervalSince1970: data.timestamp)
        return GenericValue(displayName: "Attitude", value: data.attitude, unit: None(), date: date)
    }

    public var rotationRate: GenericValue<CMRotationRate, None>? {
        guard let data = latestData else { return nil }
        let date = Date(timeIntervalSince1970: data.timestamp)
        return GenericValue(displayName: "Rotation Rate", value: data.rotationRate, unit: None(), date: date)
    }

    public var accelerationDueToGravity: GenericValue<CMAcceleration, None>? {
        guard let data = latestData else { return nil }
        let date = Date(timeIntervalSince1970: data.timestamp)
        return GenericValue(displayName: "Gravitational Acceleration", value: data.gravity, unit: None(), date: date)
    }

    public var userAcceleration: GenericValue<CMAcceleration, None>? {
        guard let data = latestData else { return nil }
        let date = Date(timeIntervalSince1970: data.timestamp)
        return GenericValue(displayName: "User Acceleration", value: data.userAcceleration, unit: None(), date: date)
    }

    public var magneticField: GenericValue<CMCalibratedMagneticField, None>? {
        guard let data = latestData else { return nil }
        let date = Date(timeIntervalSince1970: data.timestamp)
        return GenericValue(displayName: "Magnetic Field", value: data.magneticField, unit: None(), date: date)
    }

    @available(iOS 11.0, *)
    public var heading: GenericValue<Double, None>? {
        guard let data = latestData else { return nil }
        let date = Date(timeIntervalSince1970: data.timestamp)
        return GenericValue(displayName: "Heading", value: data.heading, unit: None(), date: date)
    }

    public var latestValues: [AnyValue] {
        var latestValues = [
            attitude?.asAny(),
            rotationRate?.asAny(),
            accelerationDueToGravity?.asAny(),
            userAcceleration?.asAny(),
            magneticField?.asAny(),
        ]

        if #available(iOS 11.0, *) {
            latestValues.append(heading?.asAny())
        }

        return latestValues.compactMap { $0 }
    }

    public private(set) var updateInterval: TimeInterval?

    private var motionManager: CMMotionManager?

    public override init() {}

    deinit {
        stopUpdating()
    }

    public func stopUpdating() {
        motionManager?.stopDeviceMotionUpdates()
        motionManager = nil
        updateInterval = nil
    }

    public func startUpdating(every updateInterval: TimeInterval) {
        startUpdating(every: updateInterval, referenceFrame: nil)
    }

    public func startUpdating(every updateInterval: TimeInterval, referenceFrame: CMAttitudeReferenceFrame?) {
        if isUpdating {
            stopUpdating()
        }

        self.updateInterval = updateInterval
        let motionManager = CMMotionManager()
        self.motionManager = motionManager
        motionManager.deviceMotionUpdateInterval = updateInterval

        let handler: CMDeviceMotionHandler = { [weak self] (_ data: CMDeviceMotion?, error: Error?) in
            guard let `self` = self else { return }
            guard self.isUpdating else { return }
            guard let data = data else { return }

            self.latestData = data
            self.notifyListenersPropertyValuesUpdated()
        }

        if let referenceFrame = referenceFrame {
            motionManager.startDeviceMotionUpdates(using: referenceFrame, to: OperationQueue(), withHandler: handler)
        } else {
            motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: handler)
        }
    }
}
