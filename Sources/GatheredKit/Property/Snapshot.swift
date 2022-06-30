import Foundation

/// A snapshot of data.
public struct Snapshot<Value: Sendable>: AnySnapshot {
    /// The value captured at `date`.
    public let value: Value

    /// The point in time the data was captured.
    public let date: Date

    /// The data that was captured, erased as `Any`.
    public var typeErasedValue: Any? {
        castToOptional(value)
    }

    /**
     Create a new snapshot with the provided value and date.

     - parameter value: The captured value.
     - parameter date: The point in time the value was captured.
     */
    public init(value: Value, date: Date) {
        self.value = value
        self.date = date
    }
}

extension Snapshot: Equatable where Value: Equatable {}
extension Snapshot: Hashable where Value: Hashable {}
