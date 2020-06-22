#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine
import GatheredKitCore

public final class Gyroscope: Source, CustomisableUpdateIntervalControllable {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let name = "Gyroscope"

    public let availability: SourceAvailability

    public static var defaultUpdateInterval: TimeInterval = 1

    @available(iOS 13.0, watchOS 6.0, *)
    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return eventsSubject.eraseToAnyPublisher()
    }

    @available(iOS 13.0, watchOS 6.0, *)
    private var eventsSubject: PassthroughSubject<ControllableEvent, ControllableError> {
        return _eventsSubject as! PassthroughSubject<ControllableEvent, ControllableError>
    }

    private lazy var _eventsSubject: Any = {
        if #available(iOS 13.0, watchOS 6.0, *) {
            return PassthroughSubject<ControllableEvent, ControllableError>()
        } else {
            fatalError()
        }
    }()

    public private(set) var isUpdating: Bool = false

    public var updateInterval: TimeInterval? {
        return isUpdating ? CMMotionManager.shared.gyroUpdateInterval : nil
    }

    @OptionalCMRotationRateProperty
    public private(set) var rotationRate: CMRotationRate?

    public var allProperties: [AnyProperty] {
        return [$rotationRate]
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

    public init() {
        availability = CMMotionManager.shared.isGyroAvailable ? .available : .unavailable
        _rotationRate = .init(displayName: "Rotation Rate")
    }

    public func startUpdating(
        every updateInterval: TimeInterval
    ) {
        let motionManager = CMMotionManager.shared
        motionManager.gyroUpdateInterval = updateInterval

        guard !isUpdating else { return }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "GatheredKit Gyroscope Updates"
        motionManager.startGyroUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }

            if let error = error {
                CMMotionManager.shared.stopGyroUpdates()
                if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
                    self.eventsSubject.send(completion: .failure(.other(error)))
                } else {
                    // Fallback on earlier versions
                }
                self.state = .notMonitoring
                return
            }

            guard let data = data else { return }
            self._rotationRate.update(value: data.rotationRate, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            eventsSubject.send(.startedUpdating)
        } else {
            // Fallback on earlier versions
        }
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopGyroUpdates()
        state = .notMonitoring
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            eventsSubject.send(completion: .finished)
        } else {
            // Fallback on earlier versions
        }
    }

}
#endif
