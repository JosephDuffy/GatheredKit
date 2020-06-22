#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine
import GatheredKitCore

public final class Magnetometer: Source, CustomisableUpdateIntervalControllable {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let name = "Magnetometer"

    public let availability: SourceAvailability

    public static var defaultUpdateInterval: TimeInterval = 1

    @available(iOS 13.0, *)
    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return eventsSubject.eraseToAnyPublisher()
    }

    @available(iOS 13.0, *)
    private var eventsSubject: PassthroughSubject<ControllableEvent, ControllableError> {
        return _eventsSubject as! PassthroughSubject<ControllableEvent, ControllableError>
    }

    private lazy var _eventsSubject: Any = {
        if #available(iOS 13.0, *) {
            return PassthroughSubject<ControllableEvent, ControllableError>()
        } else {
            fatalError()
        }
    }()

    public private(set) var isUpdating: Bool = false

    public var updateInterval: TimeInterval? {
        return isUpdating ? CMMotionManager.shared.magnetometerUpdateInterval : nil
    }

    @OptionalCMMagneticFieldProperty
    public private(set) var magneticField: CMMagneticField?

    public var allProperties: [AnyProperty] {
        return [$magneticField]
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
        availability = CMMotionManager.shared.isMagnetometerAvailable ? .available : .unavailable
        _magneticField = .init(displayName: "Magnetic Field")
    }

    public func startUpdating(
        every updateInterval: TimeInterval
    ) {
        let motionManager = CMMotionManager.shared
        motionManager.magnetometerUpdateInterval = updateInterval

        guard !isUpdating else { return }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "GatheredKit Magnetometer Updates"
        motionManager.startMagnetometerUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }

            if let error = error {
                CMMotionManager.shared.stopMagnetometerUpdates()
                if #available(iOS 13.0, *) {
                    self.eventsSubject.send(completion: .failure(.other(error)))
                } else {
                    // Fallback on earlier versions
                }
                self.state = .notMonitoring
                return
            }

            guard let data = data else { return }
            self._magneticField.update(value: data.magneticField, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
        if #available(iOS 13.0, *) {
            eventsSubject.send(.startedUpdating)
        } else {
            // Fallback on earlier versions
        }
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopMagnetometerUpdates()
        state = .notMonitoring
        if #available(iOS 13.0, *) {
            eventsSubject.send(completion: .finished)
        } else {
            // Fallback on earlier versions
        }
    }

}
#endif
