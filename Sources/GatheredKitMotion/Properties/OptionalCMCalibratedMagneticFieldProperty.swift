import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMCalibratedMagneticFieldProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = CMCalibratedMagneticField?
    public typealias Formatter = CMCalibratedMagneticFieldFormatter

    public var allProperties: [AnyProperty] {
        [$accuracy, $field]
    }

    @OptionalCMMagneticFieldCalibrationAccuracyProperty
    public private(set) var accuracy: CMMagneticFieldCalibrationAccuracy?

    @OptionalCMMagneticFieldProperty
    public private(set) var field: CMMagneticField?

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get {
            value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<OptionalCMCalibratedMagneticFieldProperty> {
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
    public let formatter: CMCalibratedMagneticFieldFormatter

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public required init(
        displayName: String,
        value: Value = nil,
        formatter: Formatter = CMCalibratedMagneticFieldFormatter(),
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)

        _accuracy = .init(displayName: "Accuracy", value: value?.accuracy, date: date)
        _field = .init(displayName: "Field", value: value?.field, date: date)
    }

    @discardableResult
    public func updateValue(_ value: Value, date: Date) -> Snapshot<Value> {
        _accuracy.updateValue(value?.accuracy, date: date)
        _field.updateValue(value?.field, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
