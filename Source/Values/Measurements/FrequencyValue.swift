import Foundation

public final class FrequencyValue: MeasurementValue<UnitFrequency> { }
public final class OptionalFrequencyValue: OptionalMeasurementValue<UnitFrequency> { }

extension UnitFrequency {

    public static var radiansPerSecond: UnitFrequency {
        return UnitFrequency(symbol: "rad/s", converter: UnitConverterLinear(coefficient: 2 * Double.pi))
    }

}

extension AnyValue {

    static func frequency(
        displayName: String,
        value: Double,
        unit: UnitFrequency,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> FrequencyValue {
        return FrequencyValue(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func frequency(
        displayName: String,
        value: Double? = nil,
        unit: UnitFrequency,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalFrequencyValue {
        return OptionalFrequencyValue(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func radiansPerSecond(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> FrequencyValue {
        return FrequencyValue(displayName: displayName, value: value, unit: .radiansPerSecond, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func radiansPerSecond(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalFrequencyValue {
        return OptionalFrequencyValue(displayName: displayName, value: value, unit: .radiansPerSecond, formatter: formatter, formattedValue: formattedValue, date: date)
    }

}
