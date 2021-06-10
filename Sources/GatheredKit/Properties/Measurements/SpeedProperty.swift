import Foundation

public typealias SpeedProperty = MeasurementProperty<UnitSpeed>
public typealias OptionalSpeedProperty = OptionalMeasurementProperty<UnitSpeed>

extension AnyProperty {
    public static func speed(
        displayName: String,
        value: Double,
        unit: UnitSpeed,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> SpeedProperty {
        SpeedProperty(
            displayName: displayName, value: value, unit: unit, formatter: formatter, date: date
        )
    }

    public static func metersPerSecond(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> SpeedProperty {
        SpeedProperty(
            displayName: displayName, value: value, unit: .metersPerSecond, formatter: formatter,
            date: date
        )
    }

    public static func speed(
        displayName: String,
        value: Double? = nil,
        unit: UnitSpeed,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalSpeedProperty {
        OptionalSpeedProperty(
            displayName: displayName, value: value, unit: unit, formatter: formatter, date: date
        )
    }

    public static func metersPerSecond(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalSpeedProperty {
        OptionalSpeedProperty(
            displayName: displayName, value: value, unit: .metersPerSecond, formatter: formatter,
            date: date
        )
    }
}
