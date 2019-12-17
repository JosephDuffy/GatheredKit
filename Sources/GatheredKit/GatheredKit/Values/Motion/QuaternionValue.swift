#if canImport(CoreMotion)
import Foundation
import CoreMotion

public final class QuaternionValue: Property<CMQuaternion, QuaternionFormatter> {

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

public final class OptionalQuaternionValue: OptionalProperty<CMQuaternion, QuaternionFormatter> {

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
