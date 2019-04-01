import Foundation

public protocol AnyValue {
    var displayName: String { get }
    var backingValueAsAny: Any? { get }
    var date: Date { get }
    var anyFormatter: Foundation.Formatter { get }
    var formattedValue: String? { get }
}

public struct Value<ValueType, Formatter: Foundation.Formatter>: AnyValue {

    public struct Snapshot {
        public let value: ValueType
        public let date: Date
    }

    public var anyFormatter: Foundation.Formatter {
        return formatter
    }

    public let displayName: String

    public var snapshot: Snapshot

    public var backingValue: ValueType {
        get {
            return snapshot.value
        }
        set {
            snapshot = Snapshot(value: newValue, date: Date())
            formattedValue = nil
        }
    }

    public var date: Date {
        return snapshot.date
    }

    public let formatter: Formatter

    // TODO: Update to return formatter.value
    public fileprivate(set) var formattedValue: String?

    public var backingValueAsAny: Any? {
        return backingValue
    }

    public init(
        displayName: String,
        backingValue: ValueType,
        formatter: Formatter = Formatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.snapshot = Snapshot(value: backingValue, date: date)
        self.formatter = formatter
        self.formattedValue = formattedValue
    }

    public init<WrappedValueType>(
        displayName: String,
        backingValue: WrappedValueType? = nil,
        formatter: Formatter = Formatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) where ValueType == WrappedValueType? {
        self.displayName = displayName
        self.snapshot = Snapshot(value: backingValue, date: date)
        self.formatter = formatter
        self.formattedValue = formattedValue
    }

    /**
     Updates the data backing this `SourceProperty`
     - parameter backingValue: The new value of the data
     - parameter formattedValue: The new human-friendly formatted value. Defaults to `nil`
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public mutating func update(
        backingValue: ValueType,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        snapshot = Snapshot(value: backingValue, date: date)
        self.formattedValue = formattedValue
    }

}
