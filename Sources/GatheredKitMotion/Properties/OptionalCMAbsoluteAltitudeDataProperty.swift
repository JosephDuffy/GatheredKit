#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMAbsoluteAltitudeDataProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = CMAbsoluteAltitudeDataShim?
    #warning("TODO: Replace with a proper formatter")
    public typealias Formatter = CMAccelerationFormatter

    public var allProperties: [AnyProperty] {
        [$altitude, $accuracy, $precision]
    }

    @OptionalLengthProperty
    public private(set) var altitude: Measurement<UnitLength>?

    @OptionalLengthProperty
    public private(set) var accuracy: Measurement<UnitLength>?

    @OptionalLengthProperty
    public private(set) var precision: Measurement<UnitLength>?

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    @Published
    public var error: Error?

    public var errorsPublisher: AnyPublisher<Error?, Never> {
        $error.eraseToAnyPublisher()
    }

    public var projectedValue: ReadOnlyProperty<OptionalCMAbsoluteAltitudeDataProperty> {
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
        displayName: String,
        value: Value = nil,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)

        _altitude = .length(displayName: "Altitude", value: value?.altitude, unit: .meters)
        _accuracy = .length(displayName: "Accuracy", value: value?.accuracy, unit: .meters)
        _precision = .length(displayName: "Precision", value: value?.precision, unit: .meters)
    }

    @discardableResult
    public func updateValue(_ value: Value, date: Date) -> Snapshot<Value> {
        _altitude.updateMeasuredValue(value?.altitude, date: date)
        _accuracy.updateMeasuredValue(value?.accuracy, date: date)
        _precision.updateMeasuredValue(value?.precision, date: date)
        error = nil

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
