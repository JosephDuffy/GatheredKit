#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
public final class Gyroscope: UpdatingSource, CustomisableUpdateIntervalControllable {
    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let name = "Gyroscope"

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
        isUpdating ? motionManager.gyroUpdateInterval : nil
    }

    @OptionalCMRotationRateProperty
    public private(set) var rotationRate: CMRotationRate?

    public var allProperties: [AnyProperty] {
        [$rotationRate]
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
        self.motionManager = motionManager
        availability = motionManager.isGyroAvailable ? .available : .unavailable
        _rotationRate = .init(displayName: "Rotation Rate")
    }

    deinit {
        motionManager.stopGyroUpdates()
    }

    /**
     Start providing updates every ``updateInterval`` seconds. The update interval
     is shared across instance of ``Gyroscope``.
     */
    public func startUpdating(
        every updateInterval: TimeInterval
    ) {
        motionManager.gyroUpdateInterval = updateInterval

        guard !isUpdating else { return }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "GatheredKit Gyroscope Updates"
        motionManager.startGyroUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }

            if let error = error {
                self.motionManager.stopGyroUpdates()
                self.eventsSubject.send(.stoppedUpdating(error: error))
                self.state = .notMonitoring
                return
            }

            guard let data = data else { return }
            self._rotationRate.updateValue(data.rotationRate, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
        eventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        motionManager.stopGyroUpdates()
        state = .notMonitoring
        eventsSubject.send(.stoppedUpdating())
    }
}
#endif
