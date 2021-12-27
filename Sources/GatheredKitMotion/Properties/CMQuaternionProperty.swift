#if os(iOS) || os(watchOS)
import CoreMotion
import Foundation
import GatheredKit

@propertyWrapper
public final class CMQuaternionProperty: UpdatableProperty, PropertiesProvider {
    public typealias Value = CMQuaternion
    public typealias Formatter = CMQuaternionFormatter

    public var allProperties: [AnyProperty] {
        [
            $x,
            $y,
            $z,
            $w,
        ]
    }

    @DoubleProperty
    public private(set) var x: Double

    @DoubleProperty
    public private(set) var y: Double

    @DoubleProperty
    public private(set) var z: Double

    @DoubleProperty
    public private(set) var w: Double

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<CMQuaternionProperty> {
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
        updateSubject.eraseToAnyUpdatePublisher()
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

        _x = .init(displayName: "x", value: value.x, date: date)
        _y = .init(displayName: "y", value: value.y, date: date)
        _z = .init(displayName: "z", value: value.z, date: date)
        _w = .init(displayName: "w", value: value.z, date: date)
    }

    // MARK: Update Functions

    @discardableResult
    public func updateValue(_ value: Value, date: Date) -> Snapshot<Value> {
        _x.updateValue(value.x, date: date)
        _y.updateValue(value.y, date: date)
        _z.updateValue(value.z, date: date)
        _w.updateValue(value.z, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif