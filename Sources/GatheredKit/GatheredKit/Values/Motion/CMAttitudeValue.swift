#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion

// TODO: Add rotationMatrix

public final class CMAttitudeValue: Property<CMAttitude, CMAttitudeFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [roll, pitch, yaw]
    }

    public var roll: AngleValue {
        return .radians(displayName: "Roll".localized, value: value.roll, date: date)
    }

    public var pitch: AngleValue {
        return .radians(displayName: "Pitch".localized, value: value.pitch, date: date)
    }

    public var yaw: AngleValue {
        return .radians(displayName: "Yaw".localized, value: value.yaw, date: date)
    }

    public var quaternion: CMQuaternionValue {
        return .init(displayName: "Quaternion", value: value.quaternion, date: date)
    }

}

public final class OptionalCMAttitudeValue: OptionalProperty<CMAttitude, CMAttitudeFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [roll, pitch, yaw]
    }

    public var roll: OptionalAngleValue {
        return .radians(displayName: "Roll".localized, value: value?.roll, date: date)
    }

    public var pitch: OptionalAngleValue {
        return .radians(displayName: "Pitch".localized, value: value?.pitch, date: date)
    }

    public var yaw: OptionalAngleValue {
        return .radians(displayName: "Yaw".localized, value: value?.yaw, date: date)
    }

    public var quaternion: OptionalCMQuaternionValue {
        return .init(displayName: "Quaternion", value: value?.quaternion, date: date)
    }

}
#endif
