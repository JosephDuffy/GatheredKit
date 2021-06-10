#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine
import GatheredKit

public final class Accelerometer: UpdatingSource, CustomisableUpdateIntervalControllable {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let name = "Accelerometer"

    public let availability: SourceAvailability

    public static var defaultUpdateInterval: TimeInterval = 1

    public var sourceEventPublisher: AnyUpdatePublisher<SourceEvent> {
        return sourceEventsSubject.eraseToAnyUpdatePublisher()
    }

    private let sourceEventsSubject: UpdateSubject<SourceEvent>

    public private(set) var isUpdating: Bool = false

    public var updateInterval: TimeInterval? {
        return isUpdating ? CMMotionManager.shared.accelerometerUpdateInterval : nil
    }

    @OptionalCMAccelerationProperty public private(set) var acceleration: CMAcceleration?

    public var allProperties: [AnyProperty] { return [$acceleration] }

    private var state: State = .notMonitoring {
        didSet {
            switch state {
            case .monitoring: isUpdating = true
            case .notMonitoring: isUpdating = false
            }
        }
    }

    public init() {
        availability = CMMotionManager.shared.isAccelerometerAvailable ? .available : .unavailable
        _acceleration = .init(displayName: "Acceleration")
        sourceEventsSubject = .init()
    }

    public func startUpdating(every updateInterval: TimeInterval) {
        let motionManager = CMMotionManager.shared
        motionManager.accelerometerUpdateInterval = updateInterval

        guard !isUpdating else { return }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "GatheredKit Accelerometer Updates"
        motionManager.startAccelerometerUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                CMMotionManager.shared.stopAccelerometerUpdates()
                self.sourceEventsSubject.notifyUpdateListeners(of: .stoppedUpdating(error: error))
                self.state = .notMonitoring
                return
            }
            guard let data = data else { return }
            let snapshot = self._acceleration.updateValue(data.acceleration, date: data.date)
            self.sourceEventsSubject.notifyUpdateListeners(
                of: .propertyUpdated(property: self.$acceleration, snapshot: snapshot)
            )
        }

        state = .monitoring(updatesQueue: updatesQueue)
        sourceEventsSubject.notifyUpdateListeners(of: .startedUpdating)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopAccelerometerUpdates()
        state = .notMonitoring
        sourceEventsSubject.notifyUpdateListeners(of: .stoppedUpdating())
    }

}
#endif
