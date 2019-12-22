#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine

public final class DeviceMotion: CustomisableUpdateIntervalControllableSource, PropertiesProvider {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public static let name = "Device Motion"

    public static var availability: SourceAvailability {
        return CMMotionManager.shared.isDeviceMotionAvailable ? .available : .unavailable
    }

    public static var defaultUpdateInterval: TimeInterval = 1

    public static func availableReferenceFrames() -> CMAttitudeReferenceFrame {
        return CMMotionManager.availableAttitudeReferenceFrames()
    }

    public let publisher = Publisher()

    public var isUpdating: Bool {
        switch state {
        case .monitoring:
            return true
        case .notMonitoring:
            return false
        }
    }

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
        return [rotationRate]
    }

    private var state: State = .notMonitoring

    private var propertyUpdateCancellables: [AnyCancellable] = []

    public init() {
        propertyUpdateCancellables = publishUpdateWhenAnyPropertyUpdates()
    }

    public func startUpdating(every updateInterval: TimeInterval) {
        startUpdating(every: updateInterval, referenceFrame: nil)
    }

    public func startUpdating(
        every updateInterval: TimeInterval,
        referenceFrame: CMAttitudeReferenceFrame?
    ) {
        let updatesQueue = OperationQueue(name: "GatheredKit Device Motion Updates")
        let motionManager = CMMotionManager.shared
        motionManager.deviceMotionUpdateInterval = updateInterval

        let handler: CMDeviceMotionHandler = { [weak self] data, error in
            guard let self = self else { return }
            guard self.isUpdating else { return }
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
        publisher.send(.startedUpdating)
    }

    public func stopUpdating() {
        CMMotionManager.shared.stopDeviceMotionUpdates()
        state = .notMonitoring
        publisher.send(.stoppedUpdating)
    }

}
#endif
