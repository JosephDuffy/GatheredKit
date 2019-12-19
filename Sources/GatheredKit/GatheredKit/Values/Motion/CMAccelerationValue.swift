#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion

public final class CMAccelerationValue: Property<CMAcceleration, CMAccelerationFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [x, y, z]
    }

    public var x: AccelerationValue {
        return .gravity(displayName: "x".localized, value: value.x, date: date)
    }

    public var y: AccelerationValue {
        return .gravity(displayName: "y".localized, value: value.y, date: date)
    }

    public var z: AccelerationValue {
        return .gravity(displayName: "z".localized, value: value.z, date: date)
    }

}

public final class OptionalCMAccelerationValue: OptionalProperty<CMAcceleration, CMAccelerationFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [x, y, z]
    }

    public var x: OptionalAccelerationValue {
        return .gravity(displayName: "x".localized, value: value?.x, date: date)
    }

    public var y: OptionalAccelerationValue {
        return .gravity(displayName: "y".localized, value: value?.y, date: date)
    }

    public var z: OptionalAccelerationValue {
        return .gravity(displayName: "z".localized, value: value?.z, date: date)
    }

}
#endif
