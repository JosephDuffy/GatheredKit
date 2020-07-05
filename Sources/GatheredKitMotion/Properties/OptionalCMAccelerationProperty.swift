#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import GatheredKitCore

@propertyWrapper
public final class OptionalCMAccelerationProperty: Property, PropertiesProvider {
    public typealias Value = CMAcceleration?
    public typealias Formatter = CMAccelerationFormatter

    public var allProperties: [AnyProperty] {
        return [$x, $y, $z]
    }

    @OptionalAccelerationProperty
    public private(set) var x: Measurement<UnitAcceleration>?

    @OptionalAccelerationProperty
    public private(set) var y: Measurement<UnitAcceleration>?

    @OptionalAccelerationProperty
    public private(set) var z: Measurement<UnitAcceleration>?

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<OptionalCMAccelerationProperty> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// A human-friendly display name that describes the property.
    public let displayName: String

    /// The latest snapshot of data.
    public internal(set) var snapshot: Snapshot<Value> {
        didSet {
            updateSubject.notifyUpdateListeners(of: snapshot)
        }
    }

    /// A formatter that can be used to build a human-friendly string from the
    /// value.
    public let formatter: Formatter

    public var updatePublisher: AnyUpdatePublisher<Snapshot<Value>> {
        return updateSubject.eraseToAnyUpdatePublisher()
    }

    private let updateSubject: UpdateSubject<Snapshot<Value>>

    // MARK: Initialisers

    public required init(displayName: String, value: Value = nil, formatter: Formatter = Formatter(), date: Date = Date()) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)
        updateSubject = .init()

        _x = .gravity(displayName: "x", value: value?.x, date: date)
        _y = .gravity(displayName: "y", value: value?.y, date: date)
        _z = .gravity(displayName: "z", value: value?.z, date: date)
    }

    public func updateValue(_ value: Value, date: Date = Date()) {
        _x.updateValueIfDifferent(value?.x, date: date)
        _y.updateValueIfDifferent(value?.y, date: date)
        _z.updateValueIfDifferent(value?.z, date: date)

        snapshot = Snapshot(value: value, date: date)
    }
}
#endif
