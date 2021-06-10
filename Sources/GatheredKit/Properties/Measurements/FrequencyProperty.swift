import Foundation

public typealias FrequencyProperty = MeasurementProperty<UnitFrequency>
public typealias OptionalFrequencyProperty = OptionalMeasurementProperty<UnitFrequency>

extension AnyProperty {

    public static func frequency(
        displayName: String,
        value: Double,
        unit: UnitFrequency,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> FrequencyProperty {
        return .init(
            displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func frequency(
        displayName: String,
        value: Double? = nil,
        unit: UnitFrequency,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalFrequencyProperty {
        return .init(
            displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func radiansPerSecond(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> FrequencyProperty {
        return .init(
            displayName: displayName, value: value, unit: .radiansPerSecond, formatter: formatter,
            date: date)
    }

    public static func radiansPerSecond(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalFrequencyProperty {
        return .init(
            displayName: displayName, value: value, unit: .radiansPerSecond, formatter: formatter,
            date: date)
    }

}
