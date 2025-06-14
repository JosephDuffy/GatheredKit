import Combine
import CoreLocation
import Foundation
import GatheredKit

@MainActor
@propertyWrapper
public final class CoordinateProperty: UpdatableProperty, PropertiesProviding {
    public let id: PropertyIdentifier

    public var allProperties: [any Property] {
        [
            $latitude,
            $longitude,
        ]
    }

    public var wrappedValue: CLLocationCoordinate2D {
        get {
            snapshot.value
        }
        set {
            updateValue(newValue)
        }
    }

    public var projectedValue: some Property<CLLocationCoordinate2D> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<CLLocationCoordinate2D>

    public var snapshotsPublisher: AnyPublisher<Snapshot<CLLocationCoordinate2D>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Coodinate Properties

    @AngleProperty
    public private(set) var latitude: Measurement<UnitAngle>

    @AngleProperty
    public private(set) var longitude: Measurement<UnitAngle>

    public required init(
        id: PropertyIdentifier,
        value: CLLocationCoordinate2D,
        date: Date = Date()
    ) {
        self.id = id
        snapshot = Snapshot(value: value, date: date)
        _latitude = .degrees(
            id: id.childIdentifierForPropertyId("latitude"),
            value: value.latitude,
            date: date
        )
        _longitude = .degrees(
            id: id.childIdentifierForPropertyId("longitude"),
            value: value.longitude,
            date: date
        )
    }

    public func updateValue(_ value: CLLocationCoordinate2D, date: Date) -> Snapshot<CLLocationCoordinate2D> {
        _latitude.updateMeasuredValue(value.latitude, date: date)
        _longitude.updateMeasuredValue(value.longitude, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
