import Foundation
import CoreMotion

public final class Magnetometer: BaseSource, Source, CustomisableUpdateIntervalControllable, ValuesProvider {

    public static var defaultUpdateInterval: TimeInterval = 1

    public static var availability: SourceAvailability {
        return isAvailable ? .available : .unavailable
    }

    public static var isAvailable: Bool {
        return CMMotionManager().isMagnetometerAvailable
    }

    public static let name = "Magnetometer"

    public private(set) var magneticField: CalibratedMagneticFieldValue

    public private(set) var rawMagneticField: MagneticFieldValue

    public var allValues: [AnyValue] {
        return [magneticField, rawMagneticField]
    }

    public private(set) var updateInterval: TimeInterval?

    private var motionManager: CMMotionManager?

    public override init() {
        let date = Date()
        magneticField = CalibratedMagneticFieldValue(date: date)
        rawMagneticField = MagneticFieldValue(date: date)
    }

    deinit {
        stopUpdating()
    }

    public func stopUpdating() {
        motionManager?.stopDeviceMotionUpdates()
        motionManager?.stopMagnetometerUpdates()
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
        motionManager.magnetometerUpdateInterval = updateInterval

        let calibratedHandler: CMDeviceMotionHandler = { [weak self] (_ data: CMDeviceMotion?, error: Error?) in
            guard let `self` = self else { return }
            guard self.isUpdating else { return }

            let date: Date

            if let timestamp = data?.timestamp {
                date = Date(timeIntervalSince1970: timestamp)
            } else {
                date = Date()
            }

            self.magneticField.update(
                backingValue: data?.magneticField,
                date: date
            )
            self.notifyListenersPropertyValuesUpdated()
        }

        let rawHandler: CMMagnetometerHandler = { [weak self] (_ data: CMMagnetometerData?, error: Error?) in
            guard let `self` = self else { return }
            guard self.isUpdating else { return }

            let date: Date

            if let timestamp = data?.timestamp {
                date = Date(timeIntervalSince1970: timestamp)
            } else {
                date = Date()
            }

            self.rawMagneticField.update(
                backingValue: data?.magneticField,
                date: date
            )
            self.notifyListenersPropertyValuesUpdated()
        }

        let operationQueue = OperationQueue()
        motionManager.startDeviceMotionUpdates(
            to: operationQueue,
            withHandler: calibratedHandler
        )
        motionManager.startMagnetometerUpdates(
            to: operationQueue,
            withHandler: rawHandler
        )
    }
}
