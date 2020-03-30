#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion

// TODO: Update to not used computed values à la `CoordinateValue`
public final class CMCalibratedMagneticFieldValue: Property<CMCalibratedMagneticField, CMMagneticFieldFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [accuracy, field]
    }

    public var accuracy: MagneticFieldCalibrationAccuracyValue {
        return MagneticFieldCalibrationAccuracyValue(displayName: "value.cmcalibratedmagneticfield.value.accuracy.name", value: value.accuracy)
    }

    public var field: CMMagneticFieldValue {
        return CMMagneticFieldValue(displayName: "value.cmcalibratedmagneticfield.value.field.name".localized, value: value.field)
    }

}

// TODO: Update to not used computed values à la `CoordinateValue`
public final class OptionalCMCalibratedMagneticFieldValue: OptionalProperty<CMCalibratedMagneticField, CMMagneticFieldFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [accuracy, field]
    }

    public var accuracy: OptionalMagneticFieldCalibrationAccuracyValue {
        return OptionalMagneticFieldCalibrationAccuracyValue(displayName: "value.cmcalibratedmagneticfield.value.accuracy.name", value: value?.accuracy)
    }

    public var field: OptionalCMMagneticFieldValue {
        return OptionalCMMagneticFieldValue(displayName: "value.cmcalibratedmagneticfield.value.field.name".localized, value: value?.field)
    }

}
#endif
