import Foundation
import Combine

@available(*, deprecated, renamed: "Property")
public typealias PropertyPropertyWrapper = Property

@available(*, deprecated, renamed: "Property")
public typealias WritableProperty = Property

@propertyWrapper
open class Property<Value, Formatter, ReadOnlyProperty>: AnyProperty where Formatter: Foundation.Formatter, ReadOnlyProperty: GatheredKitCore.ReadOnlyProperty<Value, Formatter> {

    public typealias Snapshot = ReadOnlyProperty.Snapshot

    open var wrappedValue: Value {
        get {
            return property.value
        }
        set {
            property.value = newValue
        }
    }

    open var projectedValue: ReadOnlyProperty { return property }

    public let property: ReadOnlyProperty

    public var displayName: String {
        return property.displayName
    }

    public var date: Date {
        return property.date
    }

    public var typeErasedFormatter: Foundation.Formatter {
        return property.formatter
    }

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public var typeErasedPublisher: AnyPublisher<AnySnapshot, Never> {
        return property.typeErasedPublisher
    }

    public var typeErasedValue: Any? {
        return property.value
    }
    
    public required init(
        displayName: String,
        value: Value,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        let property = ReadOnlyProperty(displayName: displayName, value: value, formatter: formatter, date: date)
        self.property = property
    }

    public init(property: ReadOnlyProperty) {
        self.property = property
    }

    /**
     Updates the value backing this `Property`.

     - parameter value: The new value of the property.
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time.
     */
    open func update(
        value: Value,
        date: Date = Date()
    ) {
        property.snapshot = Snapshot(value: value, date: date)
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
    open func updateValueIfDifferent(_ value: Value, date: Date = Date()) -> Bool {
        guard value != self.property.value else { return false }
        update(value: value, date: date)
        return true
    }
}

extension Property: Equatable where Value: Equatable {
    public static func == (lhs: Property<Value, Formatter, ReadOnlyProperty>, rhs: Property<Value, Formatter, ReadOnlyProperty>) -> Bool {
        return lhs.property == rhs.property
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
