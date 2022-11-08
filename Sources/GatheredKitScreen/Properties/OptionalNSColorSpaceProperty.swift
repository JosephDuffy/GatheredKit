#if os(macOS)
import AppKit
import Combine
import GatheredKit

@propertyWrapper
public final class OptionalNSColorSpaceProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = NSColorSpace?

    public let id: PropertyIdentifier

    public var allProperties: [any Property] {
        [$model]
    }

    @BasicProperty
    public private(set) var model: NSColorSpace.Model?

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: some Property<NSColorSpace?> {
        asReadOnlyProperty
    }

    @Published
    public internal(set) var snapshot: Snapshot<Value>

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public required init(
        id: PropertyIdentifier,
        value: NSColorSpace?,
        date: Date = Date()
    ) {
        self.id = id
        snapshot = Snapshot(value: value, date: date)

        _model = .init(
            id: id.childIdentifierForPropertyId("model"),
            value: value?.colorSpaceModel
        )
    }

    @discardableResult
    public func updateValue(_ value: Value, date: Date) -> Snapshot<Value> {
        _model.updateValue(value?.colorSpaceModel, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
