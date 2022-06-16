import Combine
import CoreLocation
import Foundation
import GatheredKit

@propertyWrapper
public final class CoordinateProperty: UpdatableProperty, PropertiesProviding {
    public typealias Value = CLLocationCoordinate2D

    public var allProperties: [AnyProperty] {
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

    public var projectedValue: ReadOnlyProperty<CoordinateProperty> {
        asReadOnlyProperty
    }

    // MARK: `Property` Requirements

    /// The latest snapshot of data.
    @Published
    public internal(set) var snapshot: Snapshot<Value>

    /// A human-friendly display name that describes the property.
    public let displayName: String

    /// A formatter that can be used to build a human-friendly string from the
    /// value.
    public let formatter: CoordinateFormatter

    public var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> {
        $snapshot.eraseToAnyPublisher()
    }

    // MARK: Coodinate Properties

    @AngleProperty
    public private(set) var latitude: Measurement<UnitAngle>

    @AngleProperty
    public private(set) var longitude: Measurement<UnitAngle>

    public required init(
        displayName: String, value: CLLocationCoordinate2D,
        formatter: CoordinateFormatter = CoordinateFormatter(), date: Date = Date()
    ) {
        self.displayName = displayName
        self.formatter = formatter
        snapshot = Snapshot(value: value, date: date)
        _latitude = .degrees(displayName: "Latitude", value: value.latitude, date: date)
        _longitude = .degrees(displayName: "Longitude", value: value.longitude, date: date)
    }

    public func updateValue(_ value: CLLocationCoordinate2D, date: Date) -> Snapshot<CLLocationCoordinate2D> {
        _latitude.updateMeasuredValue(value.latitude, date: date)
        _longitude.updateMeasuredValue(value.longitude, date: date)

        let snapshot = Snapshot(value: value, date: date)
        self.snapshot = snapshot
        return snapshot
    }
}
