#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine

public final class DeviceMotion: Source, CustomisableUpdateIntervalControllable {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let name = "Device Motion"

    public let availability: SourceAvailability

    public static var defaultUpdateInterval: TimeInterval = 1

    public static func availableReferenceFrames() -> CMAttitudeReferenceFrame {
        return CMMotionManager.availableAttitudeReferenceFrames()
    }
    
    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<ControllableEvent, ControllableError>()
    
    @Published
    public private(set) var isUpdating: Bool = false

    public var updateInterval: TimeInterval? {
        return isUpdating ? CMMotionManager.shared.deviceMotionUpdateInterval : nil
    }

    public let attitude: OptionalCMAttitudeValue = .init(displayName: "Attitude")
    public let gravity: OptionalCMAccelerationValue = .init(displayName: "Gravity Acceleration")
    public let userAcceleration: OptionalCMAccelerationValue = .init(displayName: "User Acceleration")
    public let heading: OptionalAngleValue = .init(displayName: "Heading")
    public let magneticField: OptionalCMCalibratedMagneticFieldValue = .init(displayName: "Calibrated Magnetic Field")
    public let rotationRate: OptionalCMRotationRateValue = .init(displayName: "Rotation Rate")

    public var allProperties: [AnyProperty] {
        return [
            attitude,
            gravity,
            userAcceleration,
            heading,
            magneticField,
            rotationRate,
        ]
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
        availability = CMMotionManager.shared.isDeviceMotionAvailable ? .available : .unavailable
    }

    public func startUpdating(every updateInterval: TimeInterval) {
        startUpdating(every: updateInterval, referenceFrame: nil)
    }

    public func startUpdating(
        every updateInterval: TimeInterval,
        referenceFrame: CMAttitudeReferenceFrame?
    ) {
        let motionManager = CMMotionManager.shared
        motionManager.deviceMotionUpdateInterval = updateInterval
        
        guard !isUpdating else { return }

        let updatesQueue = OperationQueue(name: "GatheredKit Device Motion Updates")

        let handler: CMDeviceMotionHandler = { [weak self] data, error in
            guard let self = self else { return }

            if let error = error {
                CMMotionManager.shared.stopDeviceMotionUpdates()
                self.eventsSubject.send(completion: .failure(.other(error)))
                self.state = .notMonitoring
                return
            }

            guard let data = data else { return }

            let date = data.date
            let attitude = data.attitude
            let gravity = data.gravity
            let heading = data.heading
            let magneticField = data.magneticField
            let rotationRate = data.rotationRate
            let userAcceleration = data.userAcceleration

            self.attitude.update(value: attitude, date: date)
            self.gravity.update(value: gravity, date: date)
            self.heading.update(value: heading, date: date)
            self.magneticField.update(value: magneticField, date: date)
            self.rotationRate.update(value: rotationRate, date: date)
            self.userAcceleration.update(value: userAcceleration, date: date)
        }

        if let referenceFrame = referenceFrame {
            motionManager.startDeviceMotionUpdates(
                using: referenceFrame,
                to: updatesQueue,
                withHandler: handler
            )
        } else {
            motionManager.startDeviceMotionUpdates(
                to: updatesQueue,
                withHandler: handler
            )
        }

        state = .monitoring(updatesQueue: updatesQueue)
        eventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopDeviceMotionUpdates()
        state = .notMonitoring
        eventsSubject.send(completion: .finished)
    }

}
#endif
