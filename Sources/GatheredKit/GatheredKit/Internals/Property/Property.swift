import Foundation
import Combine

open class Property<Value, Formatter: Foundation.Formatter>: AnyProperty, Snapshot {

    public typealias Publisher = PassthroughSubject<Snapshot, Never>
    public typealias ProducedValue = Snapshot

    public struct Snapshot: GatheredKit.Snapshot {
        public let value: Value
        public let date: Date
    }

    public let publisher: Publisher

    public var typeErasedPublisher: AnyPublisher<Any, Never> {
        return publisher.map { $0 as Any }.eraseToAnyPublisher()
    }

    public var snapshot: Snapshot {
        didSet {
            publisher.send(snapshot)
        }
    }

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
        return formatter.string(for: value)
    }

    public required init(
        displayName: String,
        value: Value,
        formatter: Formatter = Formatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        self.displayName = displayName
        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        self.formatter = formatter
        publisher = .init()
    }

    /**
     Updates the value backing this `Property`.

     - parameter value: The new value of the property.
     - parameter formattedValue: The new human-friendly formatted value. Defaults to `nil`.
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     */
    public func update(
        value: Value,
        formattedValue: String? = nil,
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
