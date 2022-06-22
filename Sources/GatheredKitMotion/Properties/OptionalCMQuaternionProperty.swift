#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMQuaternionProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = CMQuaternion?
    public typealias Formatter = CMQuaternionFormatter

    public var allProperties: [AnyProperty] {
        [
            $x,
            $y,
            $z,
            $w,
        ]
    }

    @OptionalDoubleProperty
    public private(set) var x: Double?

    @OptionalDoubleProperty
    public private(set) var y: Double?

    @OptionalDoubleProperty
    public private(set) var z: Double?

    @OptionalDoubleProperty
    public private(set) var w: Double?

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<OptionalCMQuaternionProperty> {
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
    public let formatter: Formatter

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public required init(
        displayName: String, value: Value = nil,
        formatter: CMQuaternionFormatter = CMQuaternionFormatter(), date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)

        _x = .init(displayName: "x", value: value?.x, date: date)
        _y = .init(displayName: "y", value: value?.y, date: date)
        _z = .init(displayName: "z", value: value?.z, date: date)
        _w = .init(displayName: "w", value: value?.w, date: date)
    }

    // MARK: Update Functions

    @discardableResult
    public func updateValue(_ value: Value, date: Date) -> Snapshot<Value> {
        _x.updateValue(value?.x, date: date)
        _y.updateValue(value?.y, date: date)
        _z.updateValue(value?.z, date: date)
        _w.updateValue(value?.w, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
