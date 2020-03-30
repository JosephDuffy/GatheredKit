#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion

// TODO: Update to not used computed values à la `CoordinateValue`
public final class CMMagneticFieldValue: Property<CMMagneticField, CMMagneticFieldFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [x, y, z]
    }

    public var x: MagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.x.name".localized, value: value.x, date: date)
    }

    public var y: MagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.y.name".localized, value: value.y, date: date)
    }

    public var z: MagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.z.name".localized, value: value.z, date: date)
    }

}

// TODO: Update to not used computed values à la `CoordinateValue`
public final class OptionalCMMagneticFieldValue: OptionalProperty<CMMagneticField, CMMagneticFieldFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [x, y, z]
    }

    public var x: OptionalMagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.x.name".localized, value: value?.x, date: date)
    }

    public var y: OptionalMagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.y.name".localized, value: value?.y, date: date)
    }

    public var z: OptionalMagneticFieldValue {
        return .microTesla(displayName: "value.cmmagneticfield.value.z.name".localized, value: value?.z, date: date)
    }

}
#endif
