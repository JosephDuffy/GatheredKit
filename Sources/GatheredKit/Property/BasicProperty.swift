import Foundation
import GatheredKitSubscriptions

@propertyWrapper
open class BasicProperty<Value: Sendable, Error: Swift.Error>: UpdatableProperty {
    public let id: PropertyIdentifier

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            value = newValue
        }
    }

    public nonisolated var projectedValue: some Property<Value, Error> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    public internal(set) var snapshot: Snapshot<Value> {
        get {
            snapshotLock.lock()
            let snapshot = _snapshot
            snapshotLock.unlock()
            return snapshot
        }
        set {
            snapshotLock.lock()
            _snapshot = newValue
            snapshotLock.unlock()
            subscriptionsStorage.notifySubscribersOfValue(newValue)
        }
        _modify {
            snapshotLock.lock()
            var snapshot = _snapshot
            yield &snapshot
            _snapshot = snapshot
            snapshotLock.unlock()
            subscriptionsStorage.notifySubscribersOfValue(snapshot)
        }
    }

    /// The current value of the property.
    public internal(set) var value: Value {
        get {
            snapshot.value
        }
        set {
            snapshot = Snapshot(value: newValue, date: Date())
        }
    }

    private let snapshotLock = NSLock()

    private var _snapshot: Snapshot<Value>

    private let subscriptionsStorage: PropertySubscriptionsStorage<Snapshot<Value>, Error>

    // MARK: Initialisers

    public init(
        id: PropertyIdentifier,
        value: Value,
        date: Date = Date()
    ) {
        self.id = id
        let snapshot = Snapshot(value: value, date: date)
        _snapshot = snapshot
        subscriptionsStorage = PropertySubscriptionsStorage()
    }

    public func makeSubscription() -> PropertySubscription<Snapshot<Value>, Error> {
        subscriptionsStorage.makeValueSubscription()
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
        lhs: BasicProperty<Value, Error>, rhs: BasicProperty<Value, Error>
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
