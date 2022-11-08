#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMAbsoluteAltitudeDataProperty: UpdatableProperty, PropertiesProviding, Identifiable {
    public typealias Value = CMAbsoluteAltitudeDataShim?

    public let id: PropertyIdentifier

    public var allProperties: [any Property] {
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
    public internal(set) var error: Error?

    public var errorsPublisher: AnyPublisher<Error?, Never> {
        $error.eraseToAnyPublisher()
    }

    public var projectedValue: some Property<CMAbsoluteAltitudeDataShim?> {
        asReadOnlyProperty
    }

    @Published
    public internal(set) var snapshot: Snapshot<Value>

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Initialisers

    public required init(
        id: PropertyIdentifier,
        value: Value = nil,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        self.id = id
        snapshot = Snapshot(value: value, date: date)

        _altitude = .meters(
            id: id.childIdentifierForPropertyId("altitude"),
            value: value?.altitude
        )
        _accuracy = .meters(
            id: id.childIdentifierForPropertyId("accuracy"),
            value: value?.accuracy
        )
        _precision = .meters(
            id: id.childIdentifierForPropertyId("precision"),
            value: value?.precision
        )
    }

    @discardableResult
    public func updateValue(_ value: Value, date: Date) -> Snapshot<Value> {
        _altitude.updateMeasuredValue(value?.altitude, date: date)
        _accuracy.updateMeasuredValue(value?.accuracy, date: date)
        _precision.updateMeasuredValue(value?.precision, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
#endif
