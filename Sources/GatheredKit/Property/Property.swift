import Foundation

public protocol Property: AnyProperty {
    associatedtype Value
    associatedtype Formatter: Foundation.Formatter

    var snapshot: Snapshot<Value> { get }
    var value: Value { get }
    var formatter: Formatter { get }
    var asReadOnlyProperty: ReadOnlyProperty<Self> { get }
    var updatePublisher: AnyUpdatePublisher<Snapshot<Value>> { get }
}

extension Property {
    public var projectedValue: ReadOnlyProperty<Self> {
        asReadOnlyProperty
    }

    public var value: Value {
        snapshot.value
    }

    /// The date of the latest value.
    public var date: Date {
        snapshot.date
    }

    /// The type-erased current value of the property.
    public var typeErasedValue: Any? {
        snapshot.value
    }

    /// A type-erased formatter that can be used to build a human-friendly
    /// string from the value.
    public var typeErasedFormatter: Foundation.Formatter {
        formatter
    }

    public var asReadOnlyProperty: ReadOnlyProperty<Self> {
        ReadOnlyProperty(self)
    }

    public var typeErasedUpdatePublisher: AnyUpdatePublisher<AnySnapshot> {
        updatePublisher.map { $0 as AnySnapshot }.eraseToAnyUpdatePublisher()
    }
}
