import Foundation
import Combine

open class Property<Value, Formatter: Foundation.Formatter>: AnyProperty, Snapshot, ObservableObject {

    public struct Snapshot: GatheredKit.Snapshot {
        public let value: Value
        public let date: Date
    }

    public var typeErasedPublisher: AnyPublisher<AnySnapshot, Never> {
        return $snapshot.map { $0 as AnySnapshot }.eraseToAnyPublisher()
    }

    @Published
    public var snapshot: Snapshot

    public var typeErasedFormatter: Foundation.Formatter {
        return formatter
    }

    public let displayName: String

    public var value: Value {
        get {
            return snapshot.value
        }
        set {
            snapshot = Snapshot(value: newValue, date: Date())
        }
    }

    public var date: Date {
        return snapshot.date
    }

    public let formatter: Formatter

    public var formattedValue: String? {
        guard type(of: formatter) != Foundation.Formatter.self else {
            // `Formatter.string(for:)` will throw an exception when not overriden
            return nil
        }
        return formatter.string(for: value)
    }

    public required init(
        displayName: String,
        value: Value,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        self.displayName = displayName
        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        self.formatter = formatter
    }

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

extension Property where Value: Equatable {
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

extension Property: Equatable where Value: Equatable {
    public static func == (lhs: Property<Value, Formatter>, rhs: Property<Value, Formatter>) -> Bool {
        return
            lhs.displayName == rhs.displayName &&
            lhs.value == rhs.value &&
            lhs.date == rhs.date
    }
}
