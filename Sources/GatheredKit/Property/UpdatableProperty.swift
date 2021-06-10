import Foundation

public protocol UpdatableProperty: Property {
    /**
     Updates the value backing this `Property`.

     - Parameter value: The new value of the property.
     - Parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     - Returns: The new snapshot.
     */
    @discardableResult func updateValue(_ value: Value, date: Date) -> Snapshot<Value>
}

extension UpdatableProperty {
    /**
     Updates the value backing this `Property` to the provided value, with the date set to the
     current date and time.

     - Parameter value: The new value of the property.
     - Returns: The new snapshot.
     */
    @discardableResult public func updateValue(_ value: Value) -> Snapshot<Value> {
        updateValue(value, date: Date())
    }
}

extension UpdatableProperty where Value: Equatable {
    /**
     Updates the value backing this `Property`, only if the provided value is different.

     - Parameter value: The new value.
     - Parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     - Returns: The new snapshot, or `nil` if the value was not different.
     */
    @discardableResult public func updateValueIfDifferent(_ value: Value, date: Date = Date())
        -> Snapshot<Value>?
    {
        guard value != self.value else { return nil }
        return updateValue(value, date: date)
    }
}
