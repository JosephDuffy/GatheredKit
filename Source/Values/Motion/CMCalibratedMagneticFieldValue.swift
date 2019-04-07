import Foundation
import CoreMotion

public final class CMCalibratedMagneticFieldValue: Value<CMCalibratedMagneticField, CMMagneticFieldFormatter>, ValuesProvider {
    
    public var allValues: [AnyValue] {
        return [field/*, accuracy*/]
    }
    
    public var field: CMMagneticFieldValue {
        return CMMagneticFieldValue(displayName: "Field", backingValue: backingValue.field)
    }
    
    // TODO: Add accuracy
    
}

public final class OptionalCMCalibratedMagneticFieldValue: OptionalValue<CMCalibratedMagneticField, CMMagneticFieldFormatter> {
    
    public var allValues: [AnyValue] {
        return [field/*, accuracy*/]
    }
    
    public var field: OptionalCMMagneticFieldValue {
        return OptionalCMMagneticFieldValue(displayName: "Field", backingValue: backingValue?.field)
    }

    // TODO: Add accuracy

}
