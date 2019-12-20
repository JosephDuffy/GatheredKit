#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine

public final class Accelerometer: Source, CustomisableUpdateIntervalControllable, PropertiesProvider {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public static let name = "Accelerometer"

    public static var availability: SourceAvailability {
        return CMMotionManager.shared.isAccelerometerAvailable ? .available : .unavailable
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
        return isUpdating ? CMMotionManager.shared.accelerometerUpdateInterval : nil
    }

    public let acceleration: OptionalCMAccelerationValue = .init(displayName: "Acceleration")

    public var allProperties: [AnyProperty] {
        return [acceleration]
    }

    private var state: State = .notMonitoring

    private var propertyUpdateCancellables: [AnyCancellable] = []

    public init() {
        propertyUpdateCancellables = publishUpdateWhenAnyPropertyUpdates()
    }

    public func startUpdating(
        every updateInterval: TimeInterval
    ) {
        let updatesQueue = OperationQueue(name: "GatheredKit Accelerometer Updates")
        let motionManager = CMMotionManager.shared

        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.showsDeviceMovementDisplay = true
        motionManager.startAccelerometerUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                // TODO: Bubble up error
                print(error)
            }
            guard let data = data else { return }
            self.acceleration.update(value: data.acceleration, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
        publisher.send(.startedUpdating)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopAccelerometerUpdates()
        state = .notMonitoring
        publisher.send(.stoppedUpdating)
    }

}
#endif
