import Foundation

public final class LengthValue: MeasurementProperty<UnitLength> { }
public final class OptionalLengthValue: OptionalMeasurementProperty<UnitLength> { }

public extension AnyProperty {

    static func length(
        displayName: String,
        value: Double,
        unit: UnitLength,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> LengthValue {
        return LengthValue(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func length(
        displayName: String,
        value: Double? = nil,
        unit: UnitLength,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalLengthValue {
        return OptionalLengthValue(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func meters(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> LengthValue {
        return LengthValue(displayName: displayName, value: value, unit: .meters, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func meters(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalLengthValue {
        return OptionalLengthValue(displayName: displayName, value: value, unit: .meters, formatter: formatter, formattedValue: formattedValue, date: date)
    }

}
