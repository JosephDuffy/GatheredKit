import Combine
import Foundation

@dynamicMemberLookup
public final class ReadOnlyProperty<WrappedProperty: Property>: Property {
    public typealias Value = WrappedProperty.Value

    public var id: PropertyIdentifier {
        wrapped.id
    }

    public var date: Date {
        wrapped.date
    }

    public var snapshot: Snapshot<WrappedProperty.Value> {
        wrapped.snapshot
    }

    public var snapshotsPublisher: AnyPublisher<Snapshot<WrappedProperty.Value>, Never> {
        wrapped.snapshotsPublisher
    }

    private let wrapped: WrappedProperty

    public init(_ wrapped: WrappedProperty) {
        self.wrapped = wrapped
    }

    public subscript<Value>(dynamicMember keyPath: KeyPath<WrappedProperty, Value>) -> Value {
        wrapped[keyPath: keyPath]
    }
}

extension ReadOnlyProperty: PropertiesProviding where WrappedProperty: PropertiesProviding {
    public var allProperties: [any Property] {
        wrapped.allProperties
    }
}

extension Property {
    @inlinable
    public var asReadOnlyProperty: ReadOnlyProperty<Self> {
        ReadOnlyProperty(self)
    }
}
