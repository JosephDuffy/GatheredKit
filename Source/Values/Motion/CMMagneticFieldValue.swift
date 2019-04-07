import Foundation
import CoreMotion

public final class CMMagneticFieldValue: Value<CMMagneticField, CMMagneticFieldFormatter>, ValuesProvider {
    
    public var allValues: [AnyValue] {
        return [x, y, z]
    }
    
    public var x: MagneticFieldValue {
        return .microTesla(displayName: "X Axis", value: backingValue.x, date: date)
    }
    
    public var y: MagneticFieldValue {
        return .microTesla(displayName: "Y Axis", value: backingValue.y, date: date)
    }
    
    public var z: MagneticFieldValue {
        return .microTesla(displayName: "Z Axis", value: backingValue.z, date: date)
    }
    
}

public final class OptionalCMMagneticFieldValue: OptionalValue<CMMagneticField, CMMagneticFieldFormatter>, ValuesProvider {
    
    public var allValues: [AnyValue] {
        return [x, y, z]
    }
    
    public var x: OptionalMagneticFieldValue {
        return .microTesla(displayName: "X Axis", value: backingValue?.x, date: date)
    }
    
    public var y: OptionalMagneticFieldValue {
        return .microTesla(displayName: "Y Axis", value: backingValue?.y, date: date)
    }
    
    public var z: OptionalMagneticFieldValue {
        return .microTesla(displayName: "Z Axis", value: backingValue?.z, date: date)
    }
    
}
