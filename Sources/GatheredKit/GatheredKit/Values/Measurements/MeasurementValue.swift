import Foundation

@propertyWrapper
open class MeasurementProperty<Unit: Foundation.Unit>: Property<Measurement<Unit>, MeasurementFormatter> {

    public var measurement: Measurement<Unit> {
        return value
    }

    public var unit: Unit {
        return value.unit
    }

    open override var wrappedValue: Value {
        get {
            return value
        }
        set {
            value = newValue
        }
    }

    open override var projectedValue: Metadata { return metadata }

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
        let measurement = Measurement(value: value, unit: self.measurement.unit)
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
        guard value != self.value.value else { return false }
        update(value: value, date: date)
        return true
    }

}

@propertyWrapper
public class OptionalMeasurementProperty<Unit: Foundation.Dimension>: OptionalProperty<Measurement<Unit>, MeasurementFormatter> {

    public var measurement: Measurement<Unit>? {
        return value
    }

    public let unit: Unit

    open override var wrappedValue: Value {
        get {
            return value
        }
        set {
            value = newValue
        }
    }

    open override var projectedValue: Metadata { return metadata }

    public required init(
        displayName: String,
        value: Double?,
        unit: Unit = .baseUnit(),
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        self.unit = unit
        let measurement: Measurement<Unit>?
        if let value = value {
            measurement = Measurement<Unit>(value: value, unit: unit)
        } else {
            measurement = nil
        }
        super.init(displayName: displayName, value: measurement, formatter: formatter, date: date)
    }

    public required override init(displayName: String, value measurement: Measurement<Unit>? = nil, formatter: MeasurementFormatter = MeasurementFormatter(), date: Date = Date()) {
        unit = measurement?.unit ?? .baseUnit()
        super.init(displayName: displayName, value: measurement, formatter: formatter, date: date)
    }

    public func update(
        value: Double,
        date: Date = Date()
    ) {
        update(value: Measurement(value: value, unit: unit), date: date)
    }

    /**
    Updates the value backing this `Property`, only if the provided value is different.

     - Parameter value: The new value.
     - Parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     - Returns: `true` if the value was updated, otherwise `false`.
     */
    @discardableResult
    public func updateValueIfDifferent(_ value: Double, date: Date = Date()) -> Bool {
        if let existingValue = self.value?.value {
            guard value != existingValue else { return false }
            update(value: value, date: date)
            return true
        } else {
            update(value: value, date: date)
            return true
        }
    }

}

public extension AnyProperty {

    static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        value: Double,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> MeasurementProperty<Unit> {
        let measurement = Measurement(value: value, unit: unit)
        return MeasurementProperty<Unit>(
            displayName: displayName,
            value: measurement,
            formatter: formatter,
            date: date
        )
    }

    static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        value: Double? = nil,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalMeasurementProperty<Unit> {
        let measurement: Measurement<Unit>?
        if let value = value {
            measurement = Measurement(value: value, unit: unit)
        } else {
            measurement = nil
        }
        return OptionalMeasurementProperty<Unit>(
            displayName: displayName,
            value: measurement,
            formatter: formatter,
            date: date
        )
    }

}
