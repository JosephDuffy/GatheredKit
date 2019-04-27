import Foundation
import CoreMotion

public final class Magnetometer: CoreMotionSource, Source, ValuesProvider {

    public static var availability: SourceAvailability {
        return isAvailable ? .available : .unavailable
    }

    public static var isAvailable: Bool {
        return CMMotionManager().isMagnetometerAvailable
    }

    public static let name = "source.magnetometer.name".localized

    public let magneticField: OptionalCMCalibratedMagneticFieldValue

    public let rawMagneticField: OptionalCMMagneticFieldValue

    public var allValues: [AnyValue] {
        return [magneticField, rawMagneticField]
    }

    public override init() {
        magneticField = OptionalCMCalibratedMagneticFieldValue(displayName: "source.magnetometer.value.calibrated_magnetic_field.name".localized)
        rawMagneticField = OptionalCMMagneticFieldValue(displayName: "source.magnetometer.value.raw_magnetic_field.name".localized)
    }

    public override func startUpdating(every updateInterval: TimeInterval) {
        super.startUpdating(every: updateInterval) { motionManager, updatesQueue in
            let calibratedHandler: CMDeviceMotionHandler = { [weak self] (_ data: CMDeviceMotion?, error: Error?) in
                guard let `self` = self else { return }
                guard self.isUpdating else { return }
                guard let data = data else { return }
                
                self.magneticField.update(
                    backingValue: data.magneticField,
                    date: data.date
                )
                
                self.notifyUpdateConsumersOfLatestValues()
            }
            
            let rawHandler: CMMagnetometerHandler = { [weak self] (_ data: CMMagnetometerData?, error: Error?) in
                guard let `self` = self else { return }
                guard self.isUpdating else { return }
                guard let data = data else { return }
                
                self.rawMagneticField.update(
                    backingValue: data.magneticField,
                    date: data.date
                )
                
                self.notifyUpdateConsumersOfLatestValues()
            }

            motionManager.deviceMotionUpdateInterval = updateInterval
            motionManager.magnetometerUpdateInterval = updateInterval
            motionManager.showsDeviceMovementDisplay = true
            
            motionManager.startDeviceMotionUpdates(
                to: updatesQueue,
                withHandler: calibratedHandler
            )
            motionManager.startMagnetometerUpdates(
                to: updatesQueue,
                withHandler: rawHandler
            )
        }
    }
    
    public override func stopUpdating() {
        motionManager?.stopDeviceMotionUpdates()
        motionManager?.stopMagnetometerUpdates()
        super.stopUpdating()
    }

}
