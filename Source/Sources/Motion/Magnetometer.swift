import Foundation
import CoreMotion

public final class Magnetometer: Source, CustomisableUpdateIntervalControllable, ValuesProvider, UpdateConsumersProvider {
    
    private enum State {
        case notMonitoring
        case monitoring(motionManager: CMMotionManager, updatesQueue: OperationQueue)
    }

    public static var defaultUpdateInterval: TimeInterval = 1

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
    
    public var updateConsumers: [UpdatesConsumer]
    
    public var updateInterval: TimeInterval? {
        return motionManager?.deviceMotionUpdateInterval
    }
    
    private var state: State
    
    private var motionManager: CMMotionManager? {
        switch state {
        case .monitoring(let motionManager, _):
            return motionManager
        case .notMonitoring:
            return nil
        }
    }

    public init() {
        magneticField = OptionalCMCalibratedMagneticFieldValue(displayName: "source.magnetometer.value.calibrated_magnetic_field.name".localized)
        rawMagneticField = OptionalCMMagneticFieldValue(displayName: "source.magnetometer.value.raw_magnetic_field.name".localized)
        state = .notMonitoring
        updateConsumers = []
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating(every updateInterval: TimeInterval) {
        if isUpdating {
            stopUpdating()
        }
        
        let motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = updateInterval
        motionManager.magnetometerUpdateInterval = updateInterval
        motionManager.showsDeviceMovementDisplay = true
        let updatesQueue = OperationQueue(name: "uk.co.josephduffy.GatheredKit Magnetometer Updates")
        
        defer {
            state = .monitoring(motionManager: motionManager, updatesQueue: updatesQueue)
        }
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
    
    public func stopUpdating() {
        motionManager?.stopDeviceMotionUpdates()
        motionManager?.stopMagnetometerUpdates()
        state = .notMonitoring
    }

}
