import Foundation
import CoreMotion

public final class CMCalibratedMagneticFieldValue: Value<CMCalibratedMagneticField, CMMagneticFieldFormatter>, ValuesProvider {
    
    public var allValues: [AnyValue] {
        return [field/*, accuracy*/]
    }
    
    public var field: CMMagneticFieldValue {
        return CMMagneticFieldValue(displayName: "value.cmcalibratedmagneticfield.value.field.name".localized, backingValue: backingValue.field)
    }
    
    // TODO: Add accuracy
    
}

public final class OptionalCMCalibratedMagneticFieldValue: OptionalValue<CMCalibratedMagneticField, CMMagneticFieldFormatter>, ValuesProvider {
    
    public var allValues: [AnyValue] {
        return [field/*, accuracy*/]
    }
    
    public var field: OptionalCMMagneticFieldValue {
        return OptionalCMMagneticFieldValue(displayName: "value.cmcalibratedmagneticfield.value.field.name".localized, backingValue: backingValue?.field)
    }

    // TODO: Add accuracy

}
