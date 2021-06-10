#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import GatheredKit

@propertyWrapper
public final class CMCalibratedMagneticFieldProperty: UpdatableProperty, PropertiesProvider {
    public typealias Value = CMCalibratedMagneticField
    // TODO: Create `CMCalibratedMagneticFieldFormatter`
    public typealias Formatter = CMMagneticFieldFormatter

    public var allProperties: [AnyProperty] { return [$accuracy, $field] }

    @CMMagneticFieldCalibrationAccuracyProperty public private(set) var accuracy:
        CMMagneticFieldCalibrationAccuracy

    @CMMagneticFieldProperty public private(set) var field: CMMagneticField

    // MARK: Property Wrapper Properties

    public var wrappedValue: Value {
        get { value }
        set { updateValue(newValue) }
    }

    public var projectedValue: ReadOnlyProperty<CMCalibratedMagneticFieldProperty> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// A human-friendly display name that describes the property.
    public let displayName: String

    /// The latest snapshot of data.
    public internal(set) var snapshot: Snapshot<Value> {
        didSet { updateSubject.notifyUpdateListeners(of: snapshot) }
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
        displayName: String,
        value: Value,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)
        updateSubject = .init()

        _accuracy = .init(displayName: "Accuracy", value: value.accuracy, date: date)
        _field = .init(displayName: "Field", value: value.field, date: date)
    }

    @discardableResult public func updateValue(_ value: Value, date: Date) -> Snapshot<Value> {
        _accuracy.updateValue(value.accuracy, date: date)
        _field.updateValue(value.field, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
