import Foundation

@propertyWrapper
open class MeasurementProperty<Unit: Foundation.Unit>: Property<Measurement<Unit>, MeasurementFormatter, ReadOnlyMeasurementProperty<Unit>> {

    open override var wrappedValue: Measurement<Unit> {
        get {
            return super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }

    open override var projectedValue: ReadOnlyMeasurementProperty<Unit> { return super.projectedValue }

    public convenience init(
        displayName: String,
        value: Double,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        let measurement = Measurement(value: value, unit: unit)
        self.init(displayName: displayName, value: measurement, formatter: formatter, date: date)
    }

    public func update(
        value: Double,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        let measurement = Measurement(value: value, unit: property.measurement.unit)
        self.update(value: measurement, date: date)
    }

    /**
    Updates the value backing this `Property`, only if the provided value is different.

     - Parameter value: The new value.
     - Parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     - Returns: `true` if the value was updated, otherwise `false`.
     */
    @discardableResult
    public func updateValueIfDifferent(_ value: Double, date: Date = Date()) -> Bool {
        guard value != property.measurement.value else { return false }
        update(value: value, date: date)
        return true
    }

}
