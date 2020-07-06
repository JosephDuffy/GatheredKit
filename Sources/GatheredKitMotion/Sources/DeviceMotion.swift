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

    public var controllableEventUpdatePublisher: AnyUpdatePublisher<ControllableEvent> {
        return controllableEventUpdateSubject.eraseToAnyUpdatePublisher()
    }

    private let controllableEventUpdateSubject: UpdateSubject<ControllableEvent>

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

        controllableEventUpdateSubject = .init()
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
                self.controllableEventUpdateSubject.notifyUpdateListeners(
                    of: .stoppedUpdating(error: error))
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
            self._gravity.updateValue(gravity, date: date)
            self._heading.updateValueIfDifferent(heading, date: date)
            self._magneticField.updateValue(magneticField, date: date)
            self._rotationRate.updateValue(rotationRate, date: date)
            self._userAcceleration.updateValue(userAcceleration, date: date)
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
        controllableEventUpdateSubject.notifyUpdateListeners(of: .startedUpdating)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopDeviceMotionUpdates()
        state = .notMonitoring
        controllableEventUpdateSubject.notifyUpdateListeners(of: .stoppedUpdating())
    }

}
#endif
