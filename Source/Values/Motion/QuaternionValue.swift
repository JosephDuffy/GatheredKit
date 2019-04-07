import Foundation
import CoreMotion

public final class QuaternionValue: Value<CMQuaternion, QuaternionFormatter> {
    
    public var allValues: [AnyValue] {
        return [
            x,
            y,
            z,
            w,
        ]
    }

    var x: DoubleValue {
        return DoubleValue(displayName: "x", backingValue: backingValue.x)
    }

    var y: DoubleValue {
        return DoubleValue(displayName: "y", backingValue: backingValue.y)
    }

    var z: DoubleValue {
        return DoubleValue(displayName: "z", backingValue: backingValue.z)
    }

    var w: DoubleValue {
        return DoubleValue(displayName: "w", backingValue: backingValue.w)
    }
    
}

public final class OptionalQuaternionValue: OptionalValue<CMQuaternion, QuaternionFormatter> {

    public var allValues: [AnyValue] {
        return [
            x,
            y,
            z,
            w,
        ]
    }
    
    var x: OptionalDoubleValue {
        return OptionalDoubleValue(displayName: "x", backingValue: backingValue?.x)
    }

    var y: OptionalDoubleValue {
        return OptionalDoubleValue(displayName: "y", backingValue: backingValue?.y)
    }

    var z: OptionalDoubleValue {
        return OptionalDoubleValue(displayName: "z", backingValue: backingValue?.z)
    }

    var w: OptionalDoubleValue {
        return OptionalDoubleValue(displayName: "w", backingValue: backingValue?.w)
    }
    
}
