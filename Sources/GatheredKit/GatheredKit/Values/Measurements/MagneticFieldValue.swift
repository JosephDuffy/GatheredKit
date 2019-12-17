import Foundation

public final class MagneticFieldValue: MeasurementProperty<UnitMagneticField> { }
public final class OptionalMagneticFieldValue: OptionalMeasurementProperty<UnitMagneticField> { }

extension AnyProperty {
    
    static func magneticField(
        displayName: String,
        value: Double,
        unit: UnitMagneticField,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> MagneticFieldValue {
        return MagneticFieldValue(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }
    
    static func magneticField(
        displayName: String,
        value: Double? = nil,
        unit: UnitMagneticField,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalMagneticFieldValue {
        return OptionalMagneticFieldValue(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }
    
    static func tesla(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> MagneticFieldValue {
        return MagneticFieldValue(displayName: displayName, value: value, unit: .tesla, formatter: formatter, date: date)
    }
    
    static func tesla(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalMagneticFieldValue {
        return OptionalMagneticFieldValue(displayName: displayName, value: value, unit: .tesla, formatter: formatter, date: date)
    }
    
    static func microTesla(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> MagneticFieldValue {
        return MagneticFieldValue(displayName: displayName, value: value, unit: .microTesla, formatter: formatter, date: date)
    }
    
    static func microTesla(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalMagneticFieldValue {
        return OptionalMagneticFieldValue(displayName: displayName, value: value, unit: .microTesla, formatter: formatter, date: date)
    }
    
}
