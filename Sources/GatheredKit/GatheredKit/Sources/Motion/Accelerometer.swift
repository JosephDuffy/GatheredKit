#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine

public final class Accelerometer: Source, CustomisableUpdateIntervalControllable {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let name = "Accelerometer"

    public let availability: SourceAvailability

    public static var defaultUpdateInterval: TimeInterval = 1

    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<ControllableEvent, ControllableError>()

    @Published
    public private(set) var isUpdating: Bool = false

    public var updateInterval: TimeInterval? {
        return isUpdating ? CMMotionManager.shared.accelerometerUpdateInterval : nil
    }

    public let acceleration: OptionalCMAccelerationValue = .init(displayName: "Acceleration")

    public var allProperties: [AnyProperty] {
        return [acceleration]
    }

    private var state: State = .notMonitoring {
        didSet {
            switch state {
            case .monitoring:
                isUpdating = true
            case .notMonitoring:
                isUpdating = false
            }
        }
    }

    private var propertyUpdateCancellables: [AnyCancellable] = []

    public init() {
        availability = CMMotionManager.shared.isAccelerometerAvailable ? .available : .unavailable
    }

    public func startUpdating(
        every updateInterval: TimeInterval
    ) {
        let motionManager = CMMotionManager.shared
        motionManager.accelerometerUpdateInterval = updateInterval

        guard !isUpdating else { return }

        let updatesQueue = OperationQueue(name: "GatheredKit Accelerometer Updates")
        motionManager.startAccelerometerUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                CMMotionManager.shared.stopAccelerometerUpdates()
                self.eventsSubject.send(completion: .failure(.other(error)))
                self.state = .notMonitoring
                return
            }
            guard let data = data else { return }
            self.acceleration.update(value: data.acceleration, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
        eventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopAccelerometerUpdates()
        state = .notMonitoring
        eventsSubject.send(completion: .finished)
    }

}
#endif
