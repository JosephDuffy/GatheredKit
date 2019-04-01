import Foundation

public typealias MeasurementValue<Unit: Foundation.Unit> = Value<Measurement<Unit>, MeasurementFormatter>
public typealias OptionalMeasurementValue<Unit: Foundation.Unit> = Value<Measurement<Unit>?, MeasurementFormatter>

public extension AnyValue {

    static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        value: Double,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> MeasurementValue<Unit> {
        let backingValue = Measurement(value: value, unit: unit)
        return MeasurementValue<Unit>(
            displayName: displayName,
            backingValue: backingValue,
            formatter: formatter,
            formattedValue: formattedValue,
            date: date
        )
    }

    static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        value: Double? = nil,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalMeasurementValue<Unit> {
        let backingValue: Measurement<Unit>?
        if let value = value {
            backingValue = Measurement(value: value, unit: unit)
        } else {
            backingValue = nil
        }
        return OptionalMeasurementValue<Unit>(
            displayName: displayName,
            backingValue: backingValue,
            formatter: formatter,
            formattedValue: formattedValue,
            date: date
        )
    }

}
