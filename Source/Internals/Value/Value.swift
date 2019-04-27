import Foundation

open class Value<ValueType, Formatter: Foundation.Formatter>: AnyValue, Producer {
    
    public typealias ProducedValue = Snapshot
    
    public struct Snapshot {
        public let value: ValueType
        public let date: Date
        public let formattedValue: String?
    }

    public var anyFormatter: Foundation.Formatter {
        return formatter
    }

    public var snapshot: Snapshot {
        didSet {
            consumers.forEach { $0.consume(snapshot, self) }
        }
    }
    
    public let displayName: String

    public var backingValue: ValueType {
        get {
            return snapshot.value
        }
        set {
            snapshot = Snapshot(value: newValue, date: Date(), formattedValue: nil)
        }
    }

    public var date: Date {
        return snapshot.date
    }

    public let formatter: Formatter
    
    private var consumers: [AnyConsumer] = []

    public var formattedValue: String? {
        return snapshot.formattedValue ?? formatter.string(for: backingValue)
    }

    public var backingValueAsAny: Any? {
        return backingValue
    }

    public required init(
        displayName: String,
        backingValue: ValueType,
        formatter: Formatter = Formatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.snapshot = Snapshot(value: backingValue, date: date, formattedValue: formattedValue)
        self.formatter = formatter
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
        snapshot = Snapshot(value: backingValue, date: date, formattedValue: formattedValue)
    }

}
