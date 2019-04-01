import Foundation

public typealias SpeedValue = MeasurementValue<UnitSpeed>
public typealias OptionalSpeedValue = OptionalMeasurementValue<UnitSpeed>

public extension AnyValue {

    static func speed(
        displayName: String,
        value: Double,
        unit: UnitSpeed,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> SpeedValue {
        return measurement(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func speed(
        displayName: String,
        value: Double? = nil,
        unit: UnitSpeed,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalSpeedValue {
        return measurement(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func metersPerSecond(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> SpeedValue {
        return speed(displayName: displayName, value: value, unit: .metersPerSecond, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func metersPerSecond(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalSpeedValue {
        return speed(displayName: displayName, value: value, unit: .metersPerSecond, formatter: formatter, formattedValue: formattedValue, date: date)
    }

}
