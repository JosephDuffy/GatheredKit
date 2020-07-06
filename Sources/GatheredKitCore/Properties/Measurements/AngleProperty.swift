import Foundation

public typealias AngleProperty = MeasurementProperty<UnitAngle>
public typealias OptionalAngleProperty = OptionalMeasurementProperty<UnitAngle>

extension AnyProperty {

    public static func angle(
        displayName: String,
        value: Double,
        unit: UnitAngle,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AngleProperty {
        return AngleProperty(
            displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func angle(
        displayName: String,
        value: Double? = nil,
        unit: UnitAngle,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAngleProperty {
        return OptionalAngleProperty(
            displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func degrees(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AngleProperty {
        return AngleProperty(
            displayName: displayName, value: value, unit: .degrees, formatter: formatter, date: date
        )
    }

    public static func degrees(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAngleProperty {
        return OptionalAngleProperty(
            displayName: displayName, value: value, unit: .degrees, formatter: formatter, date: date
        )
    }

    public static func radians(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AngleProperty {
        return .init(
            displayName: displayName, value: value, unit: .radians, formatter: formatter, date: date
        )
    }

    public static func radians(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAngleProperty {
        return .init(
            displayName: displayName, value: value, unit: .radians, formatter: formatter, date: date
        )
    }

}
