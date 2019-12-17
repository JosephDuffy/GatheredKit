import Foundation

public final class FrequencyValue: MeasurementProperty<UnitFrequency> { }
public final class OptionalFrequencyValue: OptionalMeasurementProperty<UnitFrequency> { }

extension UnitFrequency {

    public static var radiansPerSecond: UnitFrequency {
        return UnitFrequency(symbol: "rad/s", converter: UnitConverterLinear(coefficient: 2 * Double.pi))
    }

}

extension AnyProperty {

    static func frequency(
        displayName: String,
        value: Double,
        unit: UnitFrequency,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> FrequencyValue {
        return FrequencyValue(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    static func frequency(
        displayName: String,
        value: Double? = nil,
        unit: UnitFrequency,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalFrequencyValue {
        return OptionalFrequencyValue(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    static func radiansPerSecond(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> FrequencyValue {
        return FrequencyValue(displayName: displayName, value: value, unit: .radiansPerSecond, formatter: formatter, date: date)
    }

    static func radiansPerSecond(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalFrequencyValue {
        return OptionalFrequencyValue(displayName: displayName, value: value, unit: .radiansPerSecond, formatter: formatter, date: date)
    }

}
