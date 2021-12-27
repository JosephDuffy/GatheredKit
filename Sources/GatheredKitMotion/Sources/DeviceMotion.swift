#if os(iOS) || os(watchOS)
import Combine
import CoreMotion
import Foundation
import GatheredKit

public final class DeviceMotion: UpdatingSource, CustomisableUpdateIntervalControllable {
    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let name = "Device Motion"

    public let availability: SourceAvailability

    public static var defaultUpdateInterval: TimeInterval = 1

    public static func availableReferenceFrames() -> CMAttitudeReferenceFrame {
        CMMotionManager.availableAttitudeReferenceFrames()
    }

    public var sourceEventPublisher: AnyUpdatePublisher<SourceEvent> {
        sourceEventsSubject.eraseToAnyUpdatePublisher()
    }

    private let sourceEventsSubject: UpdateSubject<SourceEvent>

    public private(set) var isUpdating: Bool = false

    public var updateInterval: TimeInterval? {
        isUpdating ? CMMotionManager.shared.deviceMotionUpdateInterval : nil
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
        [
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

        sourceEventsSubject = .init()
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
                self.sourceEventsSubject.notifyUpdateListeners(
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
            self._heading.updateMeasuredValueIfDifferent(heading, date: date)
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
        sourceEventsSubject.notifyUpdateListeners(of: .startedUpdating)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopDeviceMotionUpdates()
        state = .notMonitoring
        sourceEventsSubject.notifyUpdateListeners(of: .stoppedUpdating())
    }
}
#endif