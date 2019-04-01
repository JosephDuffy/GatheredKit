import Foundation

public typealias AngleValue = Value<Measurement<UnitAngle>, MeasurementFormatter>
public typealias OptionalAngleValue = Value<Measurement<UnitAngle>?, MeasurementFormatter>

public extension AnyValue {

    static func angle(
        displayName: String,
        value: Double,
        unit: UnitAngle,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> AngleValue {
        return measurement(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func angle(
        displayName: String,
        value: Double? = nil,
        unit: UnitAngle,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalAngleValue {
        return measurement(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func degrees(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> AngleValue {
        return angle(displayName: displayName, value: value, unit: .degrees, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func degrees(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalAngleValue {
        return angle(displayName: displayName, value: value, unit: .degrees, formatter: formatter, formattedValue: formattedValue, date: date)
    }

}
