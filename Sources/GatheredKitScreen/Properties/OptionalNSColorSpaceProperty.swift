#if os(macOS)
import AppKit
import Combine
import GatheredKit

@propertyWrapper
public final class OptionalNSColorSpaceProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = NSColorSpace?
    public typealias Formatter = NSColorSpaceFormatter

    public var allProperties: [AnyProperty] {
        [$model]
    }

    @OptionalNSColorSpaceModelProperty
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

    public var projectedValue: ReadOnlyProperty<OptionalNSColorSpaceProperty> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// A human-friendly display name that describes the property.
    public let displayName: String

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<Value>

    /// A formatter that can be used to build a human-friendly string from the
    /// value.
    public let formatter: NSColorSpaceFormatter

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public required init(
        displayName: String,
        value: NSColorSpace?,
        formatter: NSColorSpaceFormatter = NSColorSpaceFormatter(),
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)

        _model = .init(displayName: "Model", value: value?.colorSpaceModel)
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
