import Foundation
import CoreMotion

public final class DeviceAttitude: BaseSource, CustomisableUpdateIntervalSource {

    public static var defaultUpdateInterval: TimeInterval = 0.1

    public static var availability: SourceAvailability {
        return isAvailable ? .available : .unavailable
    }

    public static var isAvailable: Bool {
        return CMMotionManager().isDeviceMotionAvailable
    }

    private var latestData: CMDeviceMotion?

    public var roll: GenericValue<Double?, NumericNone> {
        return GenericValue<Double?, NumericNone>(
            name: "Roll",
            backingValue:latestData?.attitude.roll,
            unit: NumericNone(maximumFractionDigits: 20),
            date: latestData?.date ?? Date()
        )
    }

    public var pitch: GenericValue<Double?, NumericNone> {
        return GenericValue<Double?, NumericNone>(
            name: "Pitch",
            backingValue: latestData?.attitude.pitch,
            unit: NumericNone(maximumFractionDigits: 20),
            date: latestData?.date ?? Date()
        )
    }

    public var yaw: GenericValue<Double?, NumericNone> {
        return GenericValue<Double?, NumericNone>(
            name: "Yaw",
            backingValue: latestData?.attitude.yaw,
            unit: NumericNone(maximumFractionDigits: 20),
            date: latestData?.date ?? Date()
        )
    }

    public var quaternion: QuaternionValue

    @available(iOS 11.0, *)
    public var heading: GenericValue<Double?, None> {
        let formattedValue = (latestData?.heading ?? 0) < 0 ? "Unknown" : nil
        return GenericValue(
            name: "Heading",
            backingValue: latestData?.heading,
            formattedValue: formattedValue,
            unit: None(),
            date: latestData?.date ?? Date()
        )
    }

    public var rotationMatrix: RotationMatrixValue

    public var latestValues: [AnyValue] {
        if #available(iOS 11.0, *) {
            return [
                roll.asAny(),
                pitch.asAny(),
                yaw.asAny(),
                heading.asAny(),
                quaternion.asAny(),
                rotationMatrix.asAny(),
            ]
        } else {
            return [
                roll.asAny(),
                pitch.asAny(),
                yaw.asAny(),
                quaternion.asAny(),
                rotationMatrix.asAny(),
            ]
        }
    }

    public private(set) var updateInterval: TimeInterval?

    private var motionManager: CMMotionManager?

    public override init() {
        let date = Date()
        quaternion = QuaternionValue(backingValue: nil, date: date)
        rotationMatrix = RotationMatrixValue(backingValue: nil, date: date)
    }

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
            self.quaternion.update(backingValue: data.attitude.quaternion, date: data.date)
            self.rotationMatrix.update(backingValue: data.attitude.rotationMatrix, date: data.date)
            self.notifyListenersPropertyValuesUpdated()
        }

        if let referenceFrame = referenceFrame {
            motionManager.startDeviceMotionUpdates(using: referenceFrame, to: OperationQueue(), withHandler: handler)
        } else {
            motionManager.startDeviceMotionUpdates(to: OperationQueue(), withHandler: handler)
        }
    }
}

extension CMDeviceMotion {

    var date: Date {
        return Date(timeIntervalSince1970: timestamp)
    }

}
