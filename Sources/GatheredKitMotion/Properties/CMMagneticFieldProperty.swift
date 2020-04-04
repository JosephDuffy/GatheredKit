#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import GatheredKitCore

@propertyWrapper
public final class CMMagneticFieldProperty: BasicProperty<CMMagneticField, CMMagneticFieldFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [$x, $y, $z]
    }

    @MagneticFieldProperty
    public private(set) var x: Measurement<UnitMagneticField>

    @MagneticFieldProperty
    public private(set) var y: Measurement<UnitMagneticField>

    @MagneticFieldProperty
    public private(set) var z: Measurement<UnitMagneticField>

    public override var wrappedValue: CMMagneticField {
        get {
            return super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }

    public override var projectedValue: ReadOnlyProperty<CMMagneticField, CMMagneticFieldFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CMMagneticField, formatter: CMMagneticFieldFormatter = CMMagneticFieldFormatter(), date: Date = Date()) {
        _x = .microTesla(displayName: "x", value: value.x, date: date)
        _y = .microTesla(displayName: "y", value: value.y, date: date)
        _z = .microTesla(displayName: "z", value: value.z, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CMMagneticField, date: Date = Date()) {
        _x.updateValueIfDifferent(value.x, date: date)
        _y.updateValueIfDifferent(value.y, date: date)
        _z.updateValueIfDifferent(value.z, date: date)

        super.update(value: value, date: date)
    }

}

@propertyWrapper
public final class OptionalCMMagneticFieldProperty: BasicProperty<CMMagneticField?, CMMagneticFieldFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [$x, $y, $z]
    }

    @OptionalMagneticFieldProperty
    public private(set) var x: Measurement<UnitMagneticField>?

    @OptionalMagneticFieldProperty
    public private(set) var y: Measurement<UnitMagneticField>?

    @OptionalMagneticFieldProperty
    public private(set) var z: Measurement<UnitMagneticField>?

    public override var wrappedValue: CMMagneticField? {
        get {
            return super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }

    public override var projectedValue: ReadOnlyProperty<CMMagneticField?, CMMagneticFieldFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CMMagneticField? = nil, formatter: CMMagneticFieldFormatter = CMMagneticFieldFormatter(), date: Date = Date()) {
        _x = .microTesla(displayName: "x", value: value?.x, date: date)
        _y = .microTesla(displayName: "y", value: value?.y, date: date)
        _z = .microTesla(displayName: "z", value: value?.z, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CMMagneticField?, date: Date = Date()) {
        _x.updateValueIfDifferent(measuredValue: value?.x, date: date)
        _y.updateValueIfDifferent(measuredValue: value?.y, date: date)
        _z.updateValueIfDifferent(measuredValue: value?.z, date: date)

        super.update(value: value, date: date)
    }

}
#endif
