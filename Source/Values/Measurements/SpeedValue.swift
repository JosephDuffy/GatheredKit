import Foundation

public final class SpeedValue: MeasurementValue<UnitSpeed> { }
public final class OptionalSpeedValue: OptionalMeasurementValue<UnitSpeed> { }

extension AnyValue {
    
    static func speed(
        displayName: String,
        value: Double,
        unit: UnitSpeed,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> SpeedValue {
        return SpeedValue(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
    static func metersPerSecond(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> SpeedValue {
        return SpeedValue(displayName: displayName, value: value, unit: .metersPerSecond, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func speed(
        displayName: String,
        value: Double? = nil,
        unit: UnitSpeed,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalSpeedValue {
        return OptionalSpeedValue(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func metersPerSecond(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalSpeedValue {
        return OptionalSpeedValue(displayName: displayName, value: value, unit: .metersPerSecond, formatter: formatter, formattedValue: formattedValue, date: date)
    }

}
