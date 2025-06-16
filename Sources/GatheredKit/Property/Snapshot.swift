import Foundation

/// A snapshot of data.
public struct Snapshot<Value>: AnySnapshot {
    /// The value captured at `date`.
    public private(set) var value: Value

    /// The point in time the data was captured.
    public private(set) var date: Date

    /// The data that was captured, erased as `Any`.
    public var typeErasedValue: Any? {
        castToOptional(value)
    }

    /**
     Create a new snapshot with the provided value and date.

     - parameter value: The captured value.
     - parameter date: The point in time the value was captured.
     */
    public init(value: Value, date: Date = Date()) {
        self.value = value
        self.date = date
    }

    public init<Wrapped>(value: Wrapped? = nil, date: Date = Date()) where Value == Wrapped? {
        self.value = value
        self.date = date
    }

    public mutating func updateValue(_ value: Value, date: Date = Date()) {
        self.value = value
        self.date = date
    }
}

extension Snapshot: Equatable where Value: Equatable {}
extension Snapshot: Hashable where Value: Hashable {}
extension Snapshot: Sendable where Value: Sendable {}
extension Snapshot: Encodable where Value: Encodable {}
extension Snapshot: Decodable where Value: Decodable {}
