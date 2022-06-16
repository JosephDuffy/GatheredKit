import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class CMAbsoluteAltitudeDataProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = CMAbsoluteAltitudeDataShim
    public typealias Formatter = CMAccelerationFormatter

    public var allProperties: [AnyProperty] {
        [$altitude, $accuracy, $precision]
    }

    @LengthProperty
    public private(set) var altitude: Measurement<UnitLength>

    @LengthProperty
    public private(set) var accuracy: Measurement<UnitLength>

    @LengthProperty
    public private(set) var precision: Measurement<UnitLength>

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<CMAbsoluteAltitudeDataProperty> {
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
        displayName: String, value: Value, formatter: Formatter = Formatter(), date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)

        _altitude = .length(displayName: "Altitude", value: value.altitude, unit: .meters)
        _accuracy = .length(displayName: "Accuracy", value: value.accuracy, unit: .meters)
        _precision = .length(displayName: "Precision", value: value.precision, unit: .meters)
    }

    @discardableResult
    public func updateValue(_ value: Value, date: Date) -> Snapshot<Value> {
        _altitude.updateMeasuredValue(value.altitude, date: date)
        _accuracy.updateMeasuredValue(value.accuracy, date: date)
        _precision.updateMeasuredValue(value.precision, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
