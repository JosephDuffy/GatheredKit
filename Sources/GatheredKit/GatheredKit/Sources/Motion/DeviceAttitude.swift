#if os(iOS)
import Foundation
import CoreMotion

public final class DeviceAttitude: CoreMotionSource, Source, PropertiesProvider {
    
    public enum ReferenceFrame: CaseIterable {
        
        case xArbitraryZVertical
        case xArbitraryCorrectedZVertical
        case xMagneticNorthZVertical
        case xTrueNorthZVertical
        
        public var rawValue: UInt {
            return asCMAttitudeReferenceFrame.rawValue
        }
        
        public var asCMAttitudeReferenceFrame: CMAttitudeReferenceFrame {
            switch self {
            case .xArbitraryZVertical:
                return .xArbitraryZVertical
            case .xArbitraryCorrectedZVertical:
                return .xArbitraryCorrectedZVertical
            case .xMagneticNorthZVertical:
                return .xMagneticNorthZVertical
            case .xTrueNorthZVertical:
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

    public static let name = "source.device_attitude.name"
    
    public static func availableReferenceFrames() -> [ReferenceFrame] {
        let frames = CMMotionManager.availableAttitudeReferenceFrames()
        return ReferenceFrame.allCases.filter({ frames.isSuperset(of: $0.asCMAttitudeReferenceFrame )})
    }

    public let roll: OptionalDoubleValue

    public let pitch: OptionalDoubleValue

    public let yaw: OptionalDoubleValue

    public let quaternion: OptionalQuaternionValue

//    public let rotationMatrix: RotationMatrixValue

    public var allProperties: [AnyProperty] {
        return [roll, pitch, yaw, quaternion]//, rotationMatrix]
    }

    public override init() {
        roll = OptionalDoubleValue(displayName: "source.device_attitude.value.roll.name")
        pitch = OptionalDoubleValue(displayName: "source.device_attitude.value.pitch.name")
        yaw = OptionalDoubleValue(displayName: "source.device_attitude.value.yaw.name")
        quaternion = OptionalQuaternionValue(displayName: "source.device_attitude.value.quaternion.name")
        
        super.init()
    }

    public override func startUpdating(every updateInterval: TimeInterval) {
        startUpdating(every: updateInterval, referenceFrame: nil)
    }

    public func startUpdating(
        every updateInterval: TimeInterval,
        referenceFrame: CMAttitudeReferenceFrame?
    ) {
        super.startUpdating(every: updateInterval, motionManagerConfigurator: { motionManager, updatesQueue in
            let handler: CMDeviceMotionHandler = { [weak self] data, error in
                guard let self = self else { return }
                guard self.isUpdating else { return }
                guard let data = data else { return }
                let attitude = data.attitude
                let date = data.date
                
                self.roll.update(value: attitude.roll, date: date)
                self.pitch.update(value: attitude.pitch, date: date)
                self.yaw.update(value: attitude.yaw, date: date)
                self.quaternion.update(value: attitude.quaternion, date: date)
                self.notifyUpdateConsumersOfLatestValues()
            }
            
            motionManager.deviceMotionUpdateInterval = updateInterval
            motionManager.showsDeviceMovementDisplay = true
            
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
        })
    }
    
    public override func stopUpdating() {
        self.motionManager?.stopDeviceMotionUpdates()
        super.stopUpdating()
    }

}
#endif
