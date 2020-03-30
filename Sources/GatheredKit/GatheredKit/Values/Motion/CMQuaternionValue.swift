#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion

// TODO: Update to not used computed values à la `CoordinateValue`
public final class CMQuaternionValue: Property<CMQuaternion, CMQuaternionFormatter> {

    public var allProperties: [AnyProperty] {
        return [
            x,
            y,
            z,
            w,
        ]
    }

    var x: DoubleValue {
        return DoubleValue(displayName: "x", value: value.x)
    }

    var y: DoubleValue {
        return DoubleValue(displayName: "y", value: value.y)
    }

    var z: DoubleValue {
        return DoubleValue(displayName: "z", value: value.z)
    }

    var w: DoubleValue {
        return DoubleValue(displayName: "w", value: value.w)
    }

}

// TODO: Update to not used computed values à la `CoordinateValue`
public final class OptionalCMQuaternionValue: OptionalProperty<CMQuaternion, CMQuaternionFormatter> {

    public var allProperties: [AnyProperty] {
        return [
            x,
            y,
            z,
            w,
        ]
    }

    var x: OptionalDoubleValue {
        return OptionalDoubleValue(displayName: "x", value: value?.x)
    }

    var y: OptionalDoubleValue {
        return OptionalDoubleValue(displayName: "y", value: value?.y)
    }

    var z: OptionalDoubleValue {
        return OptionalDoubleValue(displayName: "z", value: value?.z)
    }

    var w: OptionalDoubleValue {
        return OptionalDoubleValue(displayName: "w", value: value?.w)
    }

}
#endif
