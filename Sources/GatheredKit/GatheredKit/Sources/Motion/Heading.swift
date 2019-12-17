#if os(iOS)
import Foundation
import CoreMotion

@available(iOS 11.0, *)
public final class Heading: CoreMotionSource, Source, PropertiesProvider {

    public enum ReferenceFrame: CaseIterable {

        case magneticNorth
        case trueNorth

        public var rawValue: UInt {
            return asCMAttitudeReferenceFrame.rawValue
        }

        public var asCMAttitudeReferenceFrame: CMAttitudeReferenceFrame {
            switch self {
            case .magneticNorth:
                return .xMagneticNorthZVertical
            case .trueNorth:
                return .xTrueNorthZVertical
            }
        }

    }

    public static var availability: SourceAvailability {
        return isAvailable ? .available : .unavailable
    }

    public static var isAvailable: Bool {
        return CMMotionManager().isDeviceMotionAvailable
    }

    public static let name = "source.heading.name"

    public static func availableReferenceFrames() -> [ReferenceFrame] {
        let frames = CMMotionManager.availableAttitudeReferenceFrames()
        return ReferenceFrame.allCases.filter({ frames.isSuperset(of: $0.asCMAttitudeReferenceFrame )})
    }

    public let heading: OptionalDoubleValue

    public var allProperties: [AnyProperty] {
        return [heading]
    }

    public override init() {
        heading = OptionalDoubleValue(displayName: "source.heading.properties.heading.display-name")
    }

    public func startUpdating(
        every updateInterval: TimeInterval,
        referenceFrame: ReferenceFrame
    ) {
        super.startUpdating(every: updateInterval, motionManagerConfigurator: { motionManager, updatesQueue in
            let handler: CMDeviceMotionHandler = { [weak self] data, error in
                guard let self = self else { return }
                guard self.isUpdating else { return }
                guard let data = data else { return }

                // TODO: Create Header formatter to allow this
                self.heading.update(
                    value: data.heading,
//                    formattedValue: data.heading < 0 ? "source.heading.value.heading.unknown-value" : nil,
                    date: data.date
                )
            }

            motionManager.deviceMotionUpdateInterval = updateInterval
            motionManager.showsDeviceMovementDisplay = true
            motionManager.startDeviceMotionUpdates(
                using: referenceFrame.asCMAttitudeReferenceFrame,
                to: updatesQueue,
                withHandler: handler
            )
        })
    }

    public override func stopUpdating() {
        self.motionManager?.stopDeviceMotionUpdates()
        super.stopUpdating()
    }

}
#endif
