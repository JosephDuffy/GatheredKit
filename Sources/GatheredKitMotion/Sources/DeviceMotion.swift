#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine
import GatheredKitCore

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
        return isUpdating ? CMMotionManager.shared.deviceMotionUpdateInterval : nil
    }

    @OptionalCMAttitudeProperty
    public private(set) var attitude: CMAttitude?

    @OptionalCMAccelerationProperty
    public private(set) var gravity: CMAcceleration?

    @OptionalCMAccelerationProperty
    public private(set) var userAcceleration: CMAcceleration?

    @OptionalAngleProperty
    public private(set) var heading: Measurement<UnitAngle>?

    @OptionalCMCalibratedMagneticFieldProperty
    public private(set) var magneticField: CMCalibratedMagneticField?

    @OptionalCMRotationRateProperty
    public private(set) var rotationRate: CMRotationRate?


    public var allProperties: [AnyProperty] {
        return [
            $attitude,
            $gravity,
            $userAcceleration,
            $heading,
            $magneticField,
            $rotationRate,
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
        _attitude = .init(displayName: "Attitude")
        _gravity = .init(displayName: "Gravity Acceleration")
        _userAcceleration = .init(displayName: "User Acceleration")
        _heading = .init(displayName: "Heading")
        _magneticField = .init(displayName: "Calibrated Magnetic Field")
        _rotationRate = .init(displayName: "Rotation Rate")
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

        let updatesQueue = OperationQueue()
        updatesQueue.name = "GatheredKit Device Motion Updates"

        let handler: CMDeviceMotionHandler = { [weak self] data, error in
            guard let self = self else { return }

            if let error = error {
                CMMotionManager.shared.stopDeviceMotionUpdates()
                if #available(iOS 13.0, *) {
                    self.eventsSubject.send(completion: .failure(.other(error)))
                } else {
                    // Fallback on earlier versions
                }
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

            self._attitude.updateValueIfDifferent(attitude, date: date)
            self._gravity.update(value: gravity, date: date)
            self._heading.updateValueIfDifferent(measuredValue: heading, date: date)
            self._magneticField.update(value: magneticField, date: date)
            self._rotationRate.update(value: rotationRate, date: date)
            self._userAcceleration.update(value: userAcceleration, date: date)
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
        if #available(iOS 13.0, *) {
            eventsSubject.send(.startedUpdating)
        } else {
            // Fallback on earlier versions
        }
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopDeviceMotionUpdates()
        state = .notMonitoring
        if #available(iOS 13.0, *) {
            eventsSubject.send(completion: .finished)
        } else {
            // Fallback on earlier versions
        }
    }

}
#endif
