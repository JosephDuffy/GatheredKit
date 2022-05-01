import Combine
import Foundation

@propertyWrapper
open class BasicProperty<Value, Formatter>: UpdatableProperty where Formatter: Foundation.Formatter {
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
        }
    }

    public var projectedValue: ReadOnlyProperty<BasicProperty<Value, Formatter>> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// A human-friendly display name that describes the property.
    public let displayName: String

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<Value>

    /// The current value of the property.
    public internal(set) var value: Value {
        get {
            snapshot.value
        }
        set {
            snapshot = Snapshot(value: newValue, date: Date())
        }
    }

    /// A formatter that can be used to build a human-friendly string from the
    /// value.
    public let formatter: Formatter

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public required init(
        displayName: String,
        value: Value,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)
    }

    // MARK: Update Functions

    /**
     Updates the value backing this `Property`.

     - parameter value: The new value of the property.
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     - Returns: The new snapshot.
     */
    @discardableResult
    public func updateValue(
        _ value: Value,
        date: Date
    ) -> Snapshot<Value> {
        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}

extension BasicProperty: Equatable where Value: Equatable {
    public static func == (
        lhs: BasicProperty<Value, Formatter>, rhs: BasicProperty<Value, Formatter>
    ) -> Bool {
        lhs.displayName == rhs.displayName && lhs.value == rhs.value && lhs.date == rhs.date
    }
}

extension BasicProperty where Value: ExpressibleByNilLiteral {
    public convenience init(
        displayName: String,
        optionalValue: Value = nil,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        self.init(displayName: displayName, value: optionalValue, formatter: formatter, date: date)
    }
}
