import Combine
import Foundation

@propertyWrapper
public final class BasicProperty<Value>: UpdatableProperty {
    public let id: PropertyIdentifier

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
        }
    }

    public var projectedValue: some Property<Value> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

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

    /// A closure that provides a default format for a given value.
    public let formatter: PropertyFormatter<Value>?

    // MARK: Initialisers

    public init(
        id: PropertyIdentifier,
        value: Value,
        formatter: PropertyFormatter<Value>?,
        date: Date = Date()
    ) {
        self.id = id
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)
    }

    public init(
        id: PropertyIdentifier,
        value: Value,
        date: Date = Date()
    ) {
        self.id = id
        self.formatter = nil
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
        lhs.id == rhs.id && lhs.snapshot == rhs.snapshot
    }
}

extension BasicProperty where Value: ExpressibleByNilLiteral {
    public convenience init(
        id: PropertyIdentifier,
        optionalValue: Value = nil,
        date: Date = Date()
    ) {
        self.init(id: id, value: optionalValue, date: date)
    }
}
