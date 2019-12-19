#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion

public final class CMRotationRateValue: Property<CMRotationRate, CMRotationRateFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [x, y, z]
    }

    public var x: FrequencyValue {
        return .radiansPerSecond(displayName: "X Axis", value: value.x, date: date)
    }

    public var y: FrequencyValue {
        return .radiansPerSecond(displayName: "Y Axis", value: value.y, date: date)
    }

    public var z: FrequencyValue {
        return .radiansPerSecond(displayName: "Z Axis", value: value.z, date: date)
    }

}

public final class OptionalCMRotationRateValue: OptionalProperty<CMRotationRate, CMRotationRateFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [x, y, z]
    }

    public var x: OptionalFrequencyValue {
        return .radiansPerSecond(displayName: "X Axis", value: value?.x, date: date)
    }

    public var y: OptionalFrequencyValue {
        return .radiansPerSecond(displayName: "Y Axis", value: value?.y, date: date)
    }

    public var z: OptionalFrequencyValue {
        return .radiansPerSecond(displayName: "Z Axis", value: value?.z, date: date)
    }

}
#endif
