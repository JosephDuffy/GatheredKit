import Foundation

public struct Snapshot<Value>: AnySnapshot {
    /// The value captured at `date`.
    public let value: Value

    /// The date the `value` was captured.
    public let date: Date

    public var typeErasedValue: Any? { return castToOptional(value) }

    /**
     Create a new snapshot with the provided value and date.

     - parameter value: The captured value.
     - parameter date: The date the value was captured.
     */
    public init(value: Value, date: Date) {
        self.value = value
        self.date = date
    }
}

extension Snapshot: Equatable where Value: Equatable {

}
