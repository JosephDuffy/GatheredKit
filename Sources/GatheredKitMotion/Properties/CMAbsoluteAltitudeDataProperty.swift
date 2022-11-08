#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
@propertyWrapper
public final class CMAbsoluteAltitudeDataProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = CMAbsoluteAltitudeDataShim

    public let id: PropertyIdentifier

    public var allProperties: [any Property] {
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

    public var projectedValue: some Property<CMAbsoluteAltitudeDataShim> {
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
        value: Value,
        date: Date = Date()
    ) {
        self.id = id
        snapshot = Snapshot(value: value, date: date)

        _altitude = .meters(
            id: id.childIdentifierForPropertyId("altitude"),
            value: value.altitude,
            date: date
        )
        _accuracy = .meters(
            id: id.childIdentifierForPropertyId("accuracy"),
            value: value.accuracy,
            date: date
        )
        _precision = .meters(
            id: id.childIdentifierForPropertyId("precision"),
            value: value.precision,
            date: date
        )
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
#endif
