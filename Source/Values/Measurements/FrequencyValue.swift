import Foundation

public typealias FrequencyValue = Value<Measurement<UnitFrequency>, MeasurementFormatter>
public typealias OptionalFrequencyValue = Value<Measurement<UnitFrequency>?, MeasurementFormatter>

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
        return measurement(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func frequency(
        displayName: String,
        value: Double? = nil,
        unit: UnitFrequency,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalFrequencyValue {
        return measurement(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func radiansPerSecond(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> FrequencyValue {
        return frequency(displayName: displayName, value: value, unit: .radiansPerSecond, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func radiansPerSecond(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalFrequencyValue {
        return frequency(displayName: displayName, value: value, unit: .radiansPerSecond, formatter: formatter, formattedValue: formattedValue, date: date)
    }

}
