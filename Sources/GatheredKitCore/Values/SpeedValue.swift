import Foundation

public final class SpeedValue: MeasurementProperty<UnitSpeed> { }
public final class OptionalSpeedValue: OptionalMeasurementProperty<UnitSpeed> { }

extension AnyProperty {

    public static func speed(
        displayName: String,
        value: Double,
        unit: UnitSpeed,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> SpeedValue {
        return SpeedValue(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func metersPerSecond(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> SpeedValue {
        return SpeedValue(displayName: displayName, value: value, unit: .metersPerSecond, formatter: formatter, date: date)
    }

    public static func speed(
        displayName: String,
        value: Double? = nil,
        unit: UnitSpeed,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalSpeedValue {
        return OptionalSpeedValue(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func metersPerSecond(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalSpeedValue {
        return OptionalSpeedValue(displayName: displayName, value: value, unit: .metersPerSecond, formatter: formatter, date: date)
    }

}
