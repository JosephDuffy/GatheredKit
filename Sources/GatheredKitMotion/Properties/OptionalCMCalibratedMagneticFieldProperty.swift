#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMCalibratedMagneticFieldProperty: UpdatableProperty, PropertiesProviding {
    public let id: PropertyIdentifier

    public var allProperties: [any Property] {
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

    public var projectedValue: some Property<CMCalibratedMagneticField?> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<CMCalibratedMagneticField?>

    public var snapshotsPublisher: AnyPublisher<Snapshot<CMCalibratedMagneticField?>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public required init(
        id: PropertyIdentifier,
        value: CMCalibratedMagneticField? = nil,
        date: Date = Date()
    ) {
        self.id = id
        snapshot = Snapshot(value: value, date: date)

        _accuracy = .init(
            id: id.childIdentifierForPropertyId("accuracy"),
            value: value?.accuracy,
            date: date
        )
        _field = .init(
            id: id.childIdentifierForPropertyId("field"),
            value: value?.field,
            date: date
        )
    }

    @discardableResult
    public func updateValue(_ value: CMCalibratedMagneticField?, date: Date) -> Snapshot<Value> {
        _accuracy.updateValue(value?.accuracy, date: date)
        _field.updateValue(value?.field, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
