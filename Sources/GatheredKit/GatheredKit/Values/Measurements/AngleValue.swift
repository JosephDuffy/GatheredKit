import Foundation

public typealias AngleValue = MeasurementProperty<UnitAngle>
public typealias OptionalAngleValue = OptionalMeasurementProperty<UnitAngle>

extension AnyProperty {

    public static func angle(
        displayName: String,
        value: Double,
        unit: UnitAngle,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AngleValue {
        return AngleValue(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func angle(
        displayName: String,
        value: Double? = nil,
        unit: UnitAngle,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAngleValue {
        return OptionalAngleValue(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func degrees(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AngleValue {
        return AngleValue(displayName: displayName, value: value, unit: .degrees, formatter: formatter, date: date)
    }

    public static func degrees(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAngleValue {
        return OptionalAngleValue(displayName: displayName, value: value, unit: .degrees, formatter: formatter, date: date)
    }

    public static func radians(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AngleValue {
        return .init(displayName: displayName, value: value, unit: .radians, formatter: formatter, date: date)
    }

    public static func radians(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAngleValue {
        return .init(displayName: displayName, value: value, unit: .radians, formatter: formatter, date: date)
    }

}
