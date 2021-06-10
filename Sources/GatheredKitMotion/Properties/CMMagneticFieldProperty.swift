#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import GatheredKit

@propertyWrapper
public final class CMMagneticFieldProperty: UpdatableProperty, PropertiesProvider {
    public typealias Value = CMMagneticField
    public typealias Formatter = CMMagneticFieldFormatter

    public var allProperties: [AnyProperty] {
        return [$x, $y, $z]
    }

    @MagneticFieldProperty
    public private(set) var x: Measurement<UnitMagneticField>

    @MagneticFieldProperty
    public private(set) var y: Measurement<UnitMagneticField>

    @MagneticFieldProperty
    public private(set) var z: Measurement<UnitMagneticField>

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<CMMagneticFieldProperty> {
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

    public required init(
        displayName: String, value: Value, formatter: Formatter = Formatter(), date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)
        updateSubject = .init()

        _x = .microTesla(displayName: "x", value: value.x, date: date)
        _y = .microTesla(displayName: "y", value: value.y, date: date)
        _z = .microTesla(displayName: "z", value: value.z, date: date)
    }

    @discardableResult
    public func updateValue(_ value: Value, date: Date) -> Snapshot<Value> {
        _x.updateMeasuredValue(value.x, date: date)
        _y.updateMeasuredValue(value.y, date: date)
        _z.updateMeasuredValue(value.z, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
