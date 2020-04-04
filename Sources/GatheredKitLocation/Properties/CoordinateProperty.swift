import Foundation
import CoreLocation
import GatheredKitCore

@propertyWrapper
public final class CoordinateProperty: BasicProperty<CLLocationCoordinate2D, CoordinateFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [
            $latitude,
            $longitude,
        ]
    }

    @AngleProperty
    public private(set) var latitude: Measurement<UnitAngle>

    @AngleProperty
    public private(set) var longitude: Measurement<UnitAngle>

    public override var wrappedValue: CLLocationCoordinate2D {
        get {
            return super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }

    public override var projectedValue: ReadOnlyProperty<CLLocationCoordinate2D, CoordinateFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CLLocationCoordinate2D, formatter: CoordinateFormatter = CoordinateFormatter(), date: Date = Date()) {
        _latitude = .degrees(displayName: "Latitude", value: value.latitude, date: date)
        _longitude = .degrees(displayName: "Longitude", value: value.longitude, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CLLocationCoordinate2D, date: Date = Date()) {
        _latitude.updateValueIfDifferent(value.latitude, date: date)
        _longitude.updateValueIfDifferent(value.longitude, date: date)

        super.update(value: value, date: date)
    }

}
