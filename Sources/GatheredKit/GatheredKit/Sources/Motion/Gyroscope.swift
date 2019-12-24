#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine

public final class Gyroscope: Source, CustomisableUpdateIntervalControllable {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public static let name = "Gyroscope"

    public static var availability: SourceAvailability {
        return CMMotionManager.shared.isGyroAvailable ? .available : .unavailable
    }

    public static var defaultUpdateInterval: TimeInterval = 1
    
    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<ControllableEvent, ControllableError>()
    
    @Published
    public private(set) var isUpdating: Bool = false

    public var updateInterval: TimeInterval? {
        return isUpdating ? CMMotionManager.shared.gyroUpdateInterval : nil
    }

    public let rotationRate: OptionalCMRotationRateValue = .init(displayName: "Rotation Rate")

    public var allProperties: [AnyProperty] {
        return [rotationRate]
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

    public init() {}

    public func startUpdating(
        every updateInterval: TimeInterval
    ) {
        let motionManager = CMMotionManager.shared
        motionManager.gyroUpdateInterval = updateInterval
        
        guard !isUpdating else { return }
        
        let updatesQueue = OperationQueue(name: "GatheredKit Gyroscope Updates")
        motionManager.startGyroUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }

            if let error = error {
                CMMotionManager.shared.stopGyroUpdates()
                self.eventsSubject.send(completion: .failure(.other(error)))
                self.state = .notMonitoring
                return
            }

            guard let data = data else { return }
            self.rotationRate.update(value: data.rotationRate, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
        eventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopGyroUpdates()
        state = .notMonitoring
        eventsSubject.send(.stoppedUpdating)
    }

}
#endif
