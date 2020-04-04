import Foundation

@available(*, deprecated, renamed: "OptionalMeasurementProperty")
public typealias WritableOptionalMeasurementProperty = OptionalMeasurementProperty

@propertyWrapper
public class OptionalMeasurementProperty<Unit: Foundation.Dimension>: OptionalProperty<Measurement<Unit>, MeasurementFormatter, OptionalReadOnlyMeasurementProperty<Unit>> {

    open override var wrappedValue: Measurement<Unit>? {
        get {
            return super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }

    open override var projectedValue: OptionalReadOnlyMeasurementProperty<Unit> { return super.projectedValue }

    public init(
        displayName: String,
        value: Double?,
        unit: Unit = .baseUnit(),
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        let property = OptionalReadOnlyMeasurementProperty<Unit>(
            displayName: displayName,
            value: value,
            unit: unit,
            formatter: formatter,
            date: date
        )
        super.init(property: property)
    }

    public required init(
        displayName: String,
        value measurement: Measurement<Unit>? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        let property = OptionalReadOnlyMeasurementProperty<Unit>(
            displayName: displayName,
            value: measurement?.value,
            unit: measurement?.unit ?? .baseUnit(),
            formatter: formatter,
            date: date
        )
        super.init(property: property)
    }

    public func update(
        measuredValue: Double?,
        date: Date = Date()
    ) {
        if let measuredValue = measuredValue {
            update(value: Measurement(value: measuredValue, unit: property.unit), date: date)
        } else {
            update(value: Measurement<Unit>?.none, date: date)
        }
    }

    /**
    Updates the value backing this `Property`, only if the provided value is different.

     - Parameter value: The new value.
     - Parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     - Returns: `true` if the value was updated, otherwise `false`.
     */
    @discardableResult
    public func updateValueIfDifferent(measuredValue: Double?, date: Date = Date()) -> Bool {
        if let measuredValue = measuredValue {
            if let existingValue = wrappedValue?.value {
                guard measuredValue != existingValue else { return false }
            }

            let measurement = Measurement(value: measuredValue, unit: property.unit)
            update(value: measurement, date: date)
            return true
        } else {
            guard wrappedValue == nil else { return false }
            update(value: nil, date: date)
            return true
        }
    }

}
