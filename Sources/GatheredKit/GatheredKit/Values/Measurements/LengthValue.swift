import Foundation

public typealias LengthValue = MeasurementProperty<UnitLength>
public typealias OptionalLengthValue = OptionalMeasurementProperty<UnitLength>

public extension AnyProperty {

    static func length(
        displayName: String,
        value: Double,
        unit: UnitLength,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> LengthValue {
        return LengthValue(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    static func length(
        displayName: String,
        value: Double? = nil,
        unit: UnitLength,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalLengthValue {
        return OptionalLengthValue(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    static func meters(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> LengthValue {
        return LengthValue(displayName: displayName, value: value, unit: .meters, formatter: formatter, date: date)
    }

    static func meters(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalLengthValue {
        return OptionalLengthValue(displayName: displayName, value: value, unit: .meters, formatter: formatter, date: date)
    }

}
