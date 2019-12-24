#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine

public final class Magnetometer: Source, CustomisableUpdateIntervalControllable {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public static let name = "Magnetometer"

    public static var availability: SourceAvailability {
        return CMMotionManager.shared.isMagnetometerAvailable ? .available : .unavailable
    }

    public static var defaultUpdateInterval: TimeInterval = 1
    
    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<ControllableEvent, ControllableError>()
    
    @Published
    public private(set) var isUpdating: Bool = false

    public var updateInterval: TimeInterval? {
        return isUpdating ? CMMotionManager.shared.magnetometerUpdateInterval : nil
    }

    public let magneticField: OptionalCMMagneticFieldValue = .init(displayName: "Magnetic Field")

    public var allProperties: [AnyProperty] {
        return [magneticField]
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
        motionManager.magnetometerUpdateInterval = updateInterval
        
        guard !isUpdating else{ return }
        
        let updatesQueue = OperationQueue(name: "GatheredKit Magnetometer Updates")
        motionManager.startMagnetometerUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }

            if let error = error {
                CMMotionManager.shared.stopMagnetometerUpdates()
                self.eventsSubject.send(completion: .failure(.other(error)))
                self.state = .notMonitoring
                return
            }

            guard let data = data else { return }
            self.magneticField.update(value: data.magneticField, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
        eventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopMagnetometerUpdates()
        state = .notMonitoring
        eventsSubject.send(.stoppedUpdating)
    }

}
#endif
