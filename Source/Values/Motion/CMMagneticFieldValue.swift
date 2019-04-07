import Foundation
import CoreMotion

public final class CMMagneticFieldValue: Value<CMMagneticField, CMMagneticFieldFormatter>, ValuesProvider {
    
    public var allValues: [AnyValue] {
        return [x, y, z]
    }
    
    public var x: MagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.x.name".localized, value: backingValue.x, date: date)
    }
    
    public var y: MagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.y.name".localized, value: backingValue.y, date: date)
    }
    
    public var z: MagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.z.name".localized, value: backingValue.z, date: date)
    }
    
}

public final class OptionalCMMagneticFieldValue: OptionalValue<CMMagneticField, CMMagneticFieldFormatter>, ValuesProvider {
    
    public var allValues: [AnyValue] {
        return [x, y, z]
    }
    
    public var x: OptionalMagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.x.name".localized, value: backingValue?.x, date: date)
    }
    
    public var y: OptionalMagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.y.name".localized, value: backingValue?.y, date: date)
    }
    
    public var z: OptionalMagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.z.name".localized, value: backingValue?.z, date: date)
    }
    
}
