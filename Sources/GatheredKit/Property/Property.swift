import Combine
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

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var snapshots: AsyncPublisher<AnyPublisher<Snapshot<Value>, Never>> {
        updatePublisher.combinePublisher.values
    }

    @available(macOS 12.0, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    public var values: AsyncPublisher<AnyPublisher<Value, Never>> {
        updatePublisher.combinePublisher.map(\.value).eraseToAnyPublisher().values
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
