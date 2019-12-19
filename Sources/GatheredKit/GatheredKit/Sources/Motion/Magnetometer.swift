#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine

public final class Magnetometer: Source, CustomisableUpdateIntervalControllable, PropertiesProvider {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public static let name = "Magnetometer"

    public static var availability: SourceAvailability {
        return CMMotionManager.shared.isMagnetometerAvailable ? .available : .unavailable
    }

    public static var defaultUpdateInterval: TimeInterval = 1

    public let publisher = Publisher()

    public var isUpdating: Bool {
        switch state {
        case .monitoring:
            return true
        case .notMonitoring:
            return false
        }
    }

    public var updateInterval: TimeInterval? {
        return isUpdating ? CMMotionManager.shared.magnetometerUpdateInterval : nil
    }

    public let magneticField: OptionalCMMagneticFieldValue = .init(displayName: "Magnetic Field")

    public var allProperties: [AnyProperty] {
        return [magneticField]
    }

    private var state: State = .notMonitoring

    private var propertyUpdateCancellables: [AnyCancellable] = []

    public init() {
        propertyUpdateCancellables = publishUpdateWhenAnyPropertyUpdates()
    }

    public func startUpdating(
        every updateInterval: TimeInterval
    ) {
        let updatesQueue = OperationQueue(name: "GatheredKit Magnetometer Updates")
        let motionManager = CMMotionManager.shared

        motionManager.magnetometerUpdateInterval = updateInterval
        motionManager.startMagnetometerUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                // TODO: Bubble up error
                print(error)
            }
            guard let data = data else { return }
            self.magneticField.update(value: data.magneticField, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopMagnetometerUpdates()
        state = .notMonitoring
    }

}
#endif
