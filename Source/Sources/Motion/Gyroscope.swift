import Foundation
import CoreMotion

public final class Gyroscope: CoreMotionSource, Source, ValuesProvider {

    public static var availability: SourceAvailability {
        return isAvailable ? .available : .unavailable
    }

    public static let name = "Gyroscope"

    public static var isAvailable: Bool {
        return CMMotionManager().isGyroAvailable
    }

    public let rotationRate: OptionalRotationRateValue

    public let rawRotationRate: OptionalRotationRateValue

    public var allValues: [AnyValue] {
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
                    backingValue: data.rotationRate,
                    date: data.date
                )
                self.notifyUpdateConsumersOfLatestValues()
            }
            
            let rawHandler: CMGyroHandler = { [weak self] (_ data: CMGyroData?, error: Error?) in
                guard let self = self else { return }
                guard self.isUpdating else { return }
                guard let data = data else { return }
                
                self.rotationRate.update(
                    backingValue: data.rotationRate,
                    date: data.date
                )
                self.notifyUpdateConsumersOfLatestValues()
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
