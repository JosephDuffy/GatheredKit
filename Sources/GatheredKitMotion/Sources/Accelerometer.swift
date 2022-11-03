#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
public final class Accelerometer: UpdatingSource, CustomisableUpdateIntervalControllable {
    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let id: SourceIdentifier

    public let availability: SourceAvailability

    public static var defaultUpdateInterval: TimeInterval = 1

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    @Published
    public private(set) var isUpdating: Bool = false

    public var isUpdatingPublisher: AnyPublisher<Bool, Never> {
        $isUpdating.eraseToAnyPublisher()
    }

    public var updateInterval: TimeInterval? {
        isUpdating ? motionManager.accelerometerUpdateInterval : nil
    }

    @OptionalCMAccelerationProperty
    public private(set) var acceleration: CMAcceleration?

    public var allProperties: [any Property] {
        [$acceleration]
    }

    private let motionManager: CMMotionManager

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

    public init(motionManager: CMMotionManager = .gatheredKitShared) {
        id = SourceIdentifier(sourceKind: .accelerometer)
        self.motionManager = motionManager
        availability = motionManager.isAccelerometerAvailable ? .available : .unavailable
        _acceleration = .init(id: id.identifierForChildPropertyWithId("acceleration"))
    }

    deinit {
        motionManager.stopAccelerometerUpdates()
    }

    /**
     Start providing updates every ``updateInterval`` seconds. The update interval
     is shared across instance of ``Accelerometer``.
     */
    public func startUpdating(
        every updateInterval: TimeInterval
    ) {
        motionManager.accelerometerUpdateInterval = updateInterval

        guard !isUpdating else { return }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "GatheredKit Accelerometer Updates"
        motionManager.startAccelerometerUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                self.motionManager.stopAccelerometerUpdates()
                self.eventsSubject.send(.stoppedUpdating(error: error))
                self.state = .notMonitoring
                return
            }
            guard let data = data else { return }

            self._acceleration.updateValue(data.acceleration, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
        eventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        motionManager.stopAccelerometerUpdates()
        state = .notMonitoring
        eventsSubject.send(.stoppedUpdating())
    }
}
#endif
