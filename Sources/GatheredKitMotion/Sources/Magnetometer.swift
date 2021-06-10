#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine
import GatheredKit

public final class Magnetometer: UpdatingSource, CustomisableUpdateIntervalControllable {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let name = "Magnetometer"

    public let availability: SourceAvailability

    public static var defaultUpdateInterval: TimeInterval = 1

    public var sourceEventPublisher: AnyUpdatePublisher<SourceEvent> {
        return sourceEventsSubject.eraseToAnyUpdatePublisher()
    }

    private let sourceEventsSubject: UpdateSubject<SourceEvent>

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
        sourceEventsSubject = .init()
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
                self.sourceEventsSubject.notifyUpdateListeners(
                    of: .stoppedUpdating(error: error))
                self.state = .notMonitoring
                return
            }

            guard let data = data else { return }
            self._magneticField.updateValue(data.magneticField, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
        sourceEventsSubject.notifyUpdateListeners(of: .startedUpdating)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopMagnetometerUpdates()
        state = .notMonitoring
        sourceEventsSubject.notifyUpdateListeners(of: .stoppedUpdating())
    }

}
#endif
