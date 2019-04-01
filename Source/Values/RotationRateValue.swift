import Foundation
import CoreMotion

extension Value where ValueType == CMRotationRate {

    public var allValues: [AnyValue] {
        return [x, y, z]
    }

    public var x: FrequencyValue {
        return .radiansPerSecond(displayName: "X Axis", value: backingValue.x, date: date)
    }

    public var y: FrequencyValue {
        return .radiansPerSecond(displayName: "Y Axis", value: backingValue.y, date: date)
    }

    public var z: FrequencyValue {
        return .radiansPerSecond(displayName: "Z Axis", value: backingValue.z, date: date)
    }

}

extension Value where ValueType == CMRotationRate? {

    public var allValues: [AnyValue] {
        return [x, y, z]
    }

    public var x: OptionalFrequencyValue {
        return .radiansPerSecond(displayName: "X Axis", value: backingValue?.x, date: date)
    }

    public var y: OptionalFrequencyValue {
        return .radiansPerSecond(displayName: "Y Axis", value: backingValue?.y, date: date)
    }

    public var z: OptionalFrequencyValue {
        return .radiansPerSecond(displayName: "Z Axis", value: backingValue?.z, date: date)
    }

}
