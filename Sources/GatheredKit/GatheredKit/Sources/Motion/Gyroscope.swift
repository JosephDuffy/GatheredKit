#if os(iOS)
import Foundation
import CoreMotion

public final class Gyroscope: CoreMotionSource, Source, PropertiesProvider {

    public static var availability: SourceAvailability {
        return isAvailable ? .available : .unavailable
    }

    public static let name = "Gyroscope"

    public static var isAvailable: Bool {
        return CMMotionManager().isGyroAvailable
    }

    public let rotationRate: OptionalRotationRateValue

    public let rawRotationRate: OptionalRotationRateValue

    public var allProperties: [AnyProperty] {
        return [rotationRate, rawRotationRate]
    }

    public override init() {
        rotationRate = OptionalRotationRateValue(
            displayName: "Rotation Rate (Calibrated)"
        )
        rawRotationRate = OptionalRotationRateValue(
            displayName: "Rotation Rate (Raw)"
        )
    }

    public override func startUpdating(every updateInterval: TimeInterval) {
        super.startUpdating(every: updateInterval, motionManagerConfigurator: { motionManager, updatesQueue in
            let calibratedHandler: CMDeviceMotionHandler = { [weak self] (_ data: CMDeviceMotion?, error: Error?) in
                guard let self = self else { return }
                guard self.isUpdating else { return }
                guard let data = data else { return }

                self.rawRotationRate.update(
                    value: data.rotationRate,
                    date: data.date
                )
            }

            let rawHandler: CMGyroHandler = { [weak self] (_ data: CMGyroData?, error: Error?) in
                guard let self = self else { return }
                guard self.isUpdating else { return }
                guard let data = data else { return }

                self.rotationRate.update(
                    value: data.rotationRate,
                    date: data.date
                )
            }

            motionManager.deviceMotionUpdateInterval = updateInterval
            motionManager.gyroUpdateInterval = updateInterval
            motionManager.showsDeviceMovementDisplay = true

            motionManager.startDeviceMotionUpdates(
                to: updatesQueue,
                withHandler: calibratedHandler
            )
            motionManager.startGyroUpdates(
                to: updatesQueue,
                withHandler: rawHandler
            )
        })
    }

    public override func stopUpdating() {
        motionManager?.stopDeviceMotionUpdates()
        motionManager?.stopGyroUpdates()
        super.stopUpdating()
    }

}
#endif
