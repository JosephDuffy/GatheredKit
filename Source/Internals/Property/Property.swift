import Foundation

open class Property<Value, Formatter: Foundation.Formatter>: AnyProperty, Producer {
    
    public typealias ProducedValue = Snapshot
    
    public struct Snapshot {
        public let value: Value
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

    public var value: Value {
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
        return snapshot.formattedValue ?? formatter.string(for: value)
    }

    public var valueAsAny: Any? {
        return value
    }

    public required init(
        displayName: String,
        value: Value,
        formatter: Formatter = Formatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.snapshot = Snapshot(value: value, date: date, formattedValue: formattedValue)
        self.formatter = formatter
    }

    /**
     Updates the data backing this `SourceProperty`

     - parameter value: The new value of the data
     - parameter formattedValue: The new human-friendly formatted value. Defaults to `nil`
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public func update(
        value: Value,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        snapshot = Snapshot(value: value, date: date, formattedValue: formattedValue)
    }

}
