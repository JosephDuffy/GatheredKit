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

    private var latestDataDate: Date {
        if let timestamp = latestData?.timestamp {
            return Date(timeIntervalSince1970: timestamp)
        } else {
            return Date()
        }
    }

    public var attitude: GenericValue<CMAttitude?, None> {
        return GenericValue(displayName: "Attitude", value: latestData?.attitude, unit: None(), date: latestDataDate)
    }

    public var rotationRate: GenericValue<CMRotationRate?, None> {
        return GenericValue(displayName: "Rotation Rate", value: latestData?.rotationRate, unit: None(), date: latestDataDate)
    }

    public var accelerationDueToGravity: GenericValue<CMAcceleration?, None> {
        return GenericValue(displayName: "Gravitational Acceleration", value: latestData?.gravity, unit: None(), date: latestDataDate)
    }

    public var userAcceleration: GenericValue<CMAcceleration?, None> {
        return GenericValue(displayName: "User Acceleration", value: latestData?.userAcceleration, unit: None(), date: latestDataDate)
    }

    public var magneticField: GenericValue<CMCalibratedMagneticField?, None> {
        return GenericValue(displayName: "Magnetic Field", value: latestData?.magneticField, unit: None(), date: latestDataDate)
    }

    @available(iOS 11.0, *)
    public var heading: GenericValue<Double?, None> {
        return GenericValue(displayName: "Heading", value: latestData?.heading, unit: None(), date: latestDataDate)
    }

    public var latestValues: [AnyValue] {
        var latestValues = [
            attitude.asAny(),
            rotationRate.asAny(),
            accelerationDueToGravity.asAny(),
            userAcceleration.asAny(),
            magneticField.asAny(),
        ]

        if #available(iOS 11.0, *) {
            latestValues.append(heading.asAny())
        }

        return latestValues
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
