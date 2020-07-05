import Foundation

@dynamicMemberLookup
public final class ReadOnlyProperty<Property: AnyProperty>: AnyProperty {

    public var displayName: String {
        wrapped.displayName
    }

    public var date: Date {
        wrapped.date
    }

    public var typeErasedFormatter: Foundation.Formatter {
        wrapped.typeErasedFormatter
    }

    public var typeErasedUpdatePublisher: AnyUpdatePublisher<AnySnapshot> {
        wrapped.typeErasedUpdatePublisher
    }

    public var typeErasedValue: Any? {
        wrapped.typeErasedValue
    }

    private let wrapped: Property

    init(_ wrapped: Property) {
        self.wrapped = wrapped
    }

    public subscript<Value>(dynamicMember keyPath: KeyPath<Property, Value>) -> Value {
        return wrapped[keyPath: keyPath]
    }
}
