import Combine
import Foundation

@propertyWrapper
open class MeasurementProperty<Unit: Foundation.Unit, Error: Swift.Error>: BasicProperty<Measurement<Unit>, Error> {
    public var measurement: Measurement<Unit> {
        value
    }

    public var unit: Unit {
        measurement.unit
    }

    public var measuredValue: Double {
        measurement.value
    }

    // MARK: Initialisers

    public init(
        id: PropertyIdentifier,
        measurement: Measurement<Unit>,
        date: Date = Date()
    ) {
        super.init(id: id, value: measurement, date: date)
    }

    public convenience init(
        id: PropertyIdentifier,
        value: Double,
        unit: Unit,
        date: Date = Date()
    ) {
        let measurement = Measurement(value: value, unit: unit)
        self.init(
            id: id,
            measurement: measurement,
            date: date
        )
    }

    // MARK: Update Functions

    @discardableResult
    public func updateMeasuredValue(
        _ measuredValue: Double,
        date: Date = Date()
    ) -> Snapshot<Value> {
        let measurement = Measurement(value: measuredValue, unit: measurement.unit)
        return updateValue(measurement, date: date)
    }

    /**
     Updates the value backing this `Property`, only if the provided value is different.

     - Parameter value: The new value.
     - Parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     - Returns: The new snapshot, or `nil` if the value was not different.
     */
    @discardableResult
    public func updateMeasuredValueIfDifferent(_ measuredValue: Double, date: Date = Date()) -> Snapshot<Value>? {
        guard measuredValue != self.measuredValue else { return nil }
        return updateMeasuredValue(measuredValue, date: date)
    }
}
