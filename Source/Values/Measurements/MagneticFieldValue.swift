import Foundation

public final class MagneticFieldValue: MeasurementValue<UnitMagneticField> { }
public final class OptionalMagneticFieldValue: OptionalMeasurementValue<UnitMagneticField> { }

extension AnyValue {
    
    static func magneticField(
        displayName: String,
        value: Double,
        unit: UnitMagneticField,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> MagneticFieldValue {
        return MagneticFieldValue(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
    static func magneticField(
        displayName: String,
        value: Double? = nil,
        unit: UnitMagneticField,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalMagneticFieldValue {
        return OptionalMagneticFieldValue(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
    static func tesla(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> MagneticFieldValue {
        return MagneticFieldValue(displayName: displayName, value: value, unit: .tesla, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
    static func tesla(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalMagneticFieldValue {
        return OptionalMagneticFieldValue(displayName: displayName, value: value, unit: .tesla, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
    static func microTesla(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> MagneticFieldValue {
        return MagneticFieldValue(displayName: displayName, value: value, unit: .microTesla, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
    static func microTesla(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalMagneticFieldValue {
        return OptionalMagneticFieldValue(displayName: displayName, value: value, unit: .microTesla, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
}
