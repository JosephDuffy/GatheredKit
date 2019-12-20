#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine

public final class Gyroscope: Source, CustomisableUpdateIntervalControllable, PropertiesProvider {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public static let name = "Gyroscope"

    public static var availability: SourceAvailability {
        return CMMotionManager.shared.isGyroAvailable ? .available : .unavailable
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
        return isUpdating ? CMMotionManager.shared.gyroUpdateInterval : nil
    }

    public let rotationRate: OptionalCMRotationRateValue = .init(displayName: "Rotation Rate")

    public var allProperties: [AnyProperty] {
        return [rotationRate]
    }

    private var state: State = .notMonitoring

    private var propertyUpdateCancellables: [AnyCancellable] = []

    public init() {
        propertyUpdateCancellables = publishUpdateWhenAnyPropertyUpdates()
    }

    public func startUpdating(
        every updateInterval: TimeInterval
    ) {
        let updatesQueue = OperationQueue(name: "GatheredKit Gyroscope Updates")
        let motionManager = CMMotionManager.shared

        motionManager.gyroUpdateInterval = updateInterval
        motionManager.startGyroUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                // TODO: Bubble up error
                print(error)
            }
            guard let data = data else { return }
            self.rotationRate.update(value: data.rotationRate, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
        publisher.send(.startedUpdating)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopGyroUpdates()
        state = .notMonitoring
        publisher.send(.stoppedUpdating)
    }

}
#endif
