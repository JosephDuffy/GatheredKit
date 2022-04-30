#if os(iOS) || os(watchOS)
import Combine
import CoreMotion
import Foundation
import GatheredKit

public final class Magnetometer: UpdatingSource, CustomisableUpdateIntervalControllable {
    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let name = "Magnetometer"

    public let availability: SourceAvailability

    public static var defaultUpdateInterval: TimeInterval = 1

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    public private(set) var isUpdating: Bool = false

    public var updateInterval: TimeInterval? {
        isUpdating ? motionManager.magnetometerUpdateInterval : nil
    }

    @OptionalCMMagneticFieldProperty
    public private(set) var magneticField: CMMagneticField?

    public var allProperties: [AnyProperty] {
        [$magneticField]
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

    private var propertiesCancellables: [AnyCancellable] = []

    public init(motionManager: CMMotionManager = .gatheredKitShared) {
        self.motionManager = motionManager
        availability = motionManager.isMagnetometerAvailable ? .available : .unavailable
        _magneticField = .init(displayName: "Magnetic Field")

        propertiesCancellables = allProperties.map { property in
            property
                .typeErasedSnapshotPublisher
                .sink { [weak property, eventsSubject] snapshot in
                    guard let property = property else { return }
                    eventsSubject.send(.propertyUpdated(property: property, snapshot: snapshot))
                }
        }
    }

    /**
     Start providing updates every ``updateInterval`` seconds. The update interval
     is shared across instance of ``Magnetometer``.
     */
    public func startUpdating(
        every updateInterval: TimeInterval
    ) {
        motionManager.magnetometerUpdateInterval = updateInterval

        guard !isUpdating else { return }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "GatheredKit Magnetometer Updates"
        motionManager.startMagnetometerUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }

            if let error = error {
                self.motionManager.stopMagnetometerUpdates()
                self.eventsSubject.send(.stoppedUpdating(error: error))
                self.state = .notMonitoring
                return
            }

            guard let data = data else { return }
            self._magneticField.updateValue(data.magneticField, date: data.date)
        }

        state = .monitoring(updatesQueue: updatesQueue)
        eventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        motionManager.stopMagnetometerUpdates()
        state = .notMonitoring
        eventsSubject.send(.stoppedUpdating())
    }
}
#endif
