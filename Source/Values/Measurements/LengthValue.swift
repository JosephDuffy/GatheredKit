import Foundation

public typealias LengthValue = Value<Measurement<UnitLength>, MeasurementFormatter>
public typealias OptionalLengthValue = Value<Measurement<UnitLength>?, MeasurementFormatter>

public extension AnyValue {

    static func length(
        displayName: String,
        value: Double,
        unit: UnitLength,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> LengthValue {
        return measurement(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func length(
        displayName: String,
        value: Double? = nil,
        unit: UnitLength,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalLengthValue {
        return measurement(displayName: displayName, value: value, unit: unit, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func meters(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> LengthValue {
        return length(displayName: displayName, value: value, unit: .meters, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    static func meters(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalLengthValue {
        return length(displayName: displayName, value: value, unit: .meters, formatter: formatter, formattedValue: formattedValue, date: date)
    }

}
