import Foundation

@available(*, deprecated, renamed: "ReadOnlyProperty")
public typealias PropertyMetadata = ReadOnlyProperty

@available(*, deprecated, renamed: "AnyProperty")
public typealias AnyPropertyMetadata = AnyProperty

open class ReadOnlyProperty<Value, Formatter: Foundation.Formatter>: AnyProperty {
    /**
     A piece of data from a specific point in time.
     */
    public struct Snapshot: GatheredKitCore.Snapshot {
        /// The value captured at `date`.
        public let value: Value

        /// The date the `value` was captured.
        public let date: Date

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

    /// A human-friendly display name that describes the property.
    public let displayName: String

    /// The latest snapshot of data.
    public internal(set) var snapshot: Snapshot {
        didSet {
            updateSubject.notifyUpdateListeners(of: snapshot)
        }
    }

    /// The current value of the property.
    public internal(set) var value: Value {
        get {
            return snapshot.value
        }
        set {
            snapshot = Snapshot(value: newValue, date: Date())
        }
    }

    /// The type-erased current value of the property.
    public var typeErasedValue: Any? {
        return snapshot.value
    }

    /// The date of the latest value.
    public var date: Date {
        return snapshot.date
    }

    /// A formatter that can be used to build a human-friendly string from the
    /// value.
    public var formatter: Formatter

    /// A type-erased formatter that can be used to build a human-friendly
    /// string from the value.
    public var typeErasedFormatter: Foundation.Formatter {
        return formatter
    }

    public var updatePublisher: AnyUpdatePublisher<Snapshot> {
        return updateSubject.eraseToAnyUpdatePublisher()
    }

    public var typeErasedUpdatePublisher: AnyUpdatePublisher<AnySnapshot> {
        return updatePublisher.map { $0 as AnySnapshot }.eraseToAnyUpdatePublisher()
    }

    private let updateSubject: UpdateSubject<Snapshot>

    public required init(displayName: String, value: Value, formatter: Formatter = Formatter(), date: Date = Date()) {
        self.displayName = displayName
        self.formatter = formatter
        self.snapshot = Snapshot(value: value, date: date)
        updateSubject = UpdateSubject()
    }
}

extension ReadOnlyProperty: Equatable where Value: Equatable {
    public static func == (lhs: ReadOnlyProperty<Value, Formatter>, rhs: ReadOnlyProperty<Value, Formatter>) -> Bool {
        return
            lhs.displayName == rhs.displayName &&
            lhs.value == rhs.value &&
            lhs.date == rhs.date
    }
}

extension ReadOnlyProperty where Value: ExpressibleByNilLiteral {

    public convenience init(
        displayName: String,
        optionalValue: Value = nil,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        self.init(displayName: displayName, value: optionalValue, formatter: formatter, date: date)
    }

}
