import Combine
import CoreLocation
import Foundation
import GatheredKit

@propertyWrapper
public final class OptionalCoordinateProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = CLLocationCoordinate2D?

    public let id: PropertyIdentifier

    public var allProperties: [any Property] {
        [
            $latitude,
            $longitude,
        ]
    }

    public var wrappedValue: CLLocationCoordinate2D? {
        get {
            snapshot.value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: ReadOnlyProperty<OptionalCoordinateProperty> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<Value>

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Coodinate Properties

    @OptionalAngleProperty
    public private(set) var latitude: Measurement<UnitAngle>?

    @OptionalAngleProperty
    public private(set) var longitude: Measurement<UnitAngle>?

    public required init(
        id: PropertyIdentifier,
        value: CLLocationCoordinate2D? = nil,
        date: Date = Date()
    ) {
        self.id = id
        snapshot = Snapshot(value: value, date: date)
        _latitude = .degrees(
            id: id.childIdentifierForPropertyId("latitude"),
            value: value?.latitude,
            date: date
        )
        _longitude = .degrees(
            id: id.childIdentifierForPropertyId("longitude"),
            value: value?.longitude,
            date: date
        )
    }

    @discardableResult
    public func updateValue(_ value: CLLocationCoordinate2D?, date: Date) -> Snapshot<CLLocationCoordinate2D?> {
        _latitude.updateMeasuredValue(value?.latitude, date: date)
        _longitude.updateMeasuredValue(value?.longitude, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
