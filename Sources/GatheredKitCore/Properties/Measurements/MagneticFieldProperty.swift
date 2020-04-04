import Foundation

public typealias MagneticFieldProperty = MeasurementProperty<UnitMagneticField>
public typealias OptionalMagneticFieldProperty = OptionalMeasurementProperty<UnitMagneticField>

extension AnyProperty {

    public static func magneticField(
        displayName: String,
        value: Double,
        unit: UnitMagneticField,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> MagneticFieldProperty {
        return MagneticFieldProperty(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func magneticField(
        displayName: String,
        value: Double? = nil,
        unit: UnitMagneticField,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalMagneticFieldProperty {
        return OptionalMagneticFieldProperty(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func tesla(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> MagneticFieldProperty {
        return MagneticFieldProperty(displayName: displayName, value: value, unit: .tesla, formatter: formatter, date: date)
    }

    public static func tesla(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalMagneticFieldProperty {
        return OptionalMagneticFieldProperty(displayName: displayName, value: value, unit: .tesla, formatter: formatter, date: date)
    }

    public static func microTesla(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> MagneticFieldProperty {
        return MagneticFieldProperty(displayName: displayName, value: value, unit: .microTesla, formatter: formatter, date: date)
    }

    public static func microTesla(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalMagneticFieldProperty {
        return OptionalMagneticFieldProperty(displayName: displayName, value: value, unit: .microTesla, formatter: formatter, date: date)
    }

}
