import Foundation
import CoreMotion

public final class CMCalibratedMagneticFieldValue: Value<CMCalibratedMagneticField, CMMagneticFieldFormatter>, ValuesProvider {
    
    public var allValues: [AnyValue] {
        return [accuracy, field]
    }
    
    public var accuracy: MagneticFieldCalibrationAccuracyValue {
        return MagneticFieldCalibrationAccuracyValue(displayName: "value.cmcalibratedmagneticfield.value.accuracy.name", backingValue: backingValue.accuracy)
    }
    
    public var field: CMMagneticFieldValue {
        return CMMagneticFieldValue(displayName: "value.cmcalibratedmagneticfield.value.field.name".localized, backingValue: backingValue.field)
    }
    
}

public final class OptionalCMCalibratedMagneticFieldValue: OptionalValue<CMCalibratedMagneticField, CMMagneticFieldFormatter>, ValuesProvider {
    
    public var allValues: [AnyValue] {
        return [accuracy, field]
    }
    
    public var accuracy: OptionalMagneticFieldCalibrationAccuracyValue {
        return OptionalMagneticFieldCalibrationAccuracyValue(displayName: "value.cmcalibratedmagneticfield.value.accuracy.name", backingValue: backingValue?.accuracy)
    }
    
    public var field: OptionalCMMagneticFieldValue {
        return OptionalCMMagneticFieldValue(displayName: "value.cmcalibratedmagneticfield.value.field.name".localized, backingValue: backingValue?.field)
    }

}
