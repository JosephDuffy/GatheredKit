import Foundation

// TODO: Rename to `AnyProperty`
public protocol AnyValue {
    var displayName: String { get }
    var backingValueAsAny: Any? { get }
    var date: Date { get }
    var anyFormatter: Foundation.Formatter { get }
    var formattedValue: String? { get }
}

open class OptionalValue<ValueType, Formatter: Foundation.Formatter>: Value<ValueType?, Formatter> {
    
    public required init(
        displayName: String,
        backingValue: ValueType? = nil,
        formatter: Formatter = Formatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        super.init(displayName: displayName, backingValue: backingValue, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
}

open class Value<ValueType, Formatter: Foundation.Formatter>: AnyValue, UpdateConsumersProvider {

    public struct Snapshot {
        public let value: ValueType
        public let date: Date
    }

    public var anyFormatter: Foundation.Formatter {
        return formatter
    }

    public let displayName: String

    public var snapshot: Snapshot {
        didSet {
            updateConsumers.forEach({ $0.comsume(values: [self], sender: self)})
        }
    }

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

    public var updateConsumers: [UpdatesConsumer] = []

    public required init(
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

    /**
     Updates the data backing this `SourceProperty`
     - parameter backingValue: The new value of the data
     - parameter formattedValue: The new human-friendly formatted value. Defaults to `nil`
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public func update(
        backingValue: ValueType,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        snapshot = Snapshot(value: backingValue, date: date)
        self.formattedValue = formattedValue
    }

}
