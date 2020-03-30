import Foundation

public typealias FrequencyValue = MeasurementProperty<UnitFrequency>
public typealias OptionalFrequencyValue = OptionalMeasurementProperty<UnitFrequency>

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
