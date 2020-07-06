import Foundation

@propertyWrapper
public final class BasicProperty<Value, Formatter>: Property where Formatter: Foundation.Formatter {
    public var wrappedValue: Value {
        get {
            return value
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
    public internal(set) var snapshot: Snapshot<Value> {
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

    /// A formatter that can be used to build a human-friendly string from the
    /// value.
    public let formatter: Formatter

    public var updatePublisher: AnyUpdatePublisher<Snapshot<Value>> {
        return updateSubject.eraseToAnyUpdatePublisher()
    }

    private let updateSubject: UpdateSubject<Snapshot<Value>>

    // MARK: Initialisers

    public required init(
        displayName: String, value: Value, formatter: Formatter = Formatter(), date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        self.snapshot = Snapshot(value: value, date: date)
        updateSubject = UpdateSubject()
    }

    // MARK: Update Functions

    /**
     Updates the value backing this `Property`.

     - parameter value: The new value of the property.
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     */
    public func update(
        value: Value,
        date: Date = Date()
    ) {
        snapshot = Snapshot(value: value, date: date)
    }
}

extension BasicProperty where Value: Equatable {
    /**
     Updates the value backing this `Property`, only if the provided value is different.

     - Parameter value: The new value.
     - Parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     - Returns: `true` if the value was updated, otherwise `false`.
     */
    @discardableResult
    public func updateValueIfDifferent(_ value: Value, date: Date = Date()) -> Bool {
        guard value != self.value else { return false }
        update(value: value, date: date)
        return true
    }
}

extension BasicProperty: Equatable where Value: Equatable {
    public static func == (
        lhs: BasicProperty<Value, Formatter>, rhs: BasicProperty<Value, Formatter>
    ) -> Bool {
        return
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
