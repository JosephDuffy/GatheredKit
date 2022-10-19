import Combine
import Foundation

@propertyWrapper
public final class BasicProperty<Value>: UpdatableProperty {
    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
        }
    }

    public var projectedValue: some Property<Value> {
        ReadOnlyProperty(self)
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

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public init(
        displayName: String,
        value: Value,
        date: Date = Date()
    ) {
        self.displayName = displayName
        snapshot = Snapshot(value: value, date: date)
    }

    @available(*, deprecated, message: "Don't pass formatter")
    public init<Formatter: Foundation.Formatter>(
        displayName: String,
        value: Value,
        formatter: Formatter,
        date: Date = Date()
    ) {
        self.displayName = displayName
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
        lhs: BasicProperty<Value>, rhs: BasicProperty<Value>
    ) -> Bool {
        lhs.displayName == rhs.displayName && lhs.snapshot == rhs.snapshot
    }
}

extension BasicProperty where Value: ExpressibleByNilLiteral {
    public convenience init(
        displayName: String,
        optionalValue: Value = nil,
        date: Date = Date()
    ) {
        self.init(displayName: displayName, value: optionalValue, date: date)
    }

    @available(*, deprecated, message: "Don't pass formatter")
    public convenience init(
        displayName: String,
        optionalValue: Value = nil,
        formatter: Formatter,
        date: Date = Date()
    ) {
        self.init(displayName: displayName, value: optionalValue, date: date)
    }
}
