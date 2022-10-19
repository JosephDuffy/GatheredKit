import Combine
import Foundation

@dynamicMemberLookup
public final class ReadOnlyProperty<WrappedProperty: Property>: Property {
    public typealias Value = WrappedProperty.Value

    public var displayName: String {
        wrapped.displayName
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

    public var typeErasedSnapshotPublisher: AnyPublisher<AnySnapshot, Never> {
        wrapped.typeErasedSnapshotPublisher
    }

    public var typeErasedValue: Any? {
        wrapped.typeErasedValue
    }

    private let wrapped: WrappedProperty

    init(_ wrapped: WrappedProperty) {
        self.wrapped = wrapped
    }

    public subscript<Value>(dynamicMember keyPath: KeyPath<WrappedProperty, Value>) -> Value {
        wrapped[keyPath: keyPath]
    }
}

extension ReadOnlyProperty: PropertiesProviding where WrappedProperty: PropertiesProviding {
    public var allProperties: [AnyProperty] {
        wrapped.allProperties
    }
}

extension Property {
    public var asReadOnlyProperty: ReadOnlyProperty<Self> {
        ReadOnlyProperty(self)
    }
}
