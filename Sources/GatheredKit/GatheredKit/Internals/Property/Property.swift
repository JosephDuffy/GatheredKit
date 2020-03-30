import Foundation
import Combine

@propertyWrapper
open class Property<Value, Formatter: Foundation.Formatter>: AnyProperty, Snapshot, ObservableObject {

    open class Metadata: PropertyMetadata {

        public let displayName: String

        public let formatter: Formatter

        @Published
        public fileprivate(set) var snapshot: Property<Value, Formatter>.Snapshot

        public var typeErasedPublisher: AnyPublisher<AnySnapshot, Never> {
            return $snapshot.map { $0 as AnySnapshot }.eraseToAnyPublisher()
        }

        public init(displayName: String, value: Value, formatter: Formatter = Formatter(), date: Date = Date()) {
            self.displayName = displayName
            self.formatter = formatter
            self.snapshot = Snapshot(value: value, date: date)
        }
        
    }

    public struct Snapshot: GatheredKit.Snapshot {
        public let value: Value
        public let date: Date
    }


    public var value: Value {
        get {
            return metadata.snapshot.value
        }
        set {
            metadata.snapshot = Snapshot(value: newValue, date: Date())
        }
    }

    open var wrappedValue: Value {
        get {
            return metadata.snapshot.value
        }
        set {
            metadata.snapshot = Snapshot(value: newValue, date: Date())
        }
    }

    open var projectedValue: Metadata { return metadata }

    public let metadata: Metadata

    public var typeErasedMetadata: AnyPropertyMetadata {
        return metadata
    }

    public init(
        displayName: String,
        value: Value,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        metadata = Metadata(displayName: displayName, value: value, formatter: formatter, date: date)
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
        metadata.snapshot = Snapshot(value: value, date: date)
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

extension Property where Value: ExpressibleByNilLiteral {

    public convenience init(
        displayName: String,
        optionalValue: Value = nil,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        self.init(displayName: displayName, value: optionalValue, formatter: formatter, date: date)
    }

}
