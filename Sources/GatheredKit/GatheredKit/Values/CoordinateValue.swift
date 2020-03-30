import Foundation
import CoreLocation

@propertyWrapper
public final class CoordinateValue: Property<CLLocationCoordinate2D, CoordinateFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [
            _latitude,
            _longitude,
        ]
    }

    @AngleValue
    public var latitude: Measurement<UnitAngle>

    @AngleValue
    public var longitude: Measurement<UnitAngle>

    public override var wrappedValue: Value {
        get {
            return value
        }
        set {
            value = newValue
        }
    }

    public override var projectedValue: Metadata { return metadata }

    public required override init(displayName: String, value: CLLocationCoordinate2D, formatter: CoordinateFormatter = CoordinateFormatter(), date: Date = Date()) {
        _latitude = .degrees(displayName: "Latitude", value: value.latitude, date: date)
        _longitude = .degrees(displayName: "Longitude", value: value.longitude, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CLLocationCoordinate2D, date: Date = Date()) {
        $latitude.updateValueIfDifferent(value.latitude, date: date)
        $longitude.updateValueIfDifferent(value.longitude, date: date)

        super.update(value: value, date: date)
    }

}

@propertyWrapper
public final class OptionalCoordinateValue: OptionalProperty<CLLocationCoordinate2D, CoordinateFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [
            $latitude,
            $longitude,
        ]
    }

    @OptionalAngleValue
    public var latitude: Measurement<UnitAngle>?

    @OptionalAngleValue
    public var longitude: Measurement<UnitAngle>?

    public override var wrappedValue: Value {
        get {
            return value
        }
        set {
            value = newValue
        }
    }

    open override var projectedValue: Metadata { return metadata }

    public required override init(displayName: String, value: CLLocationCoordinate2D? = nil, formatter: CoordinateFormatter = CoordinateFormatter(), date: Date = Date()) {
        _latitude = .degrees(displayName: "Latitude", value: value?.latitude, date: date)
        _longitude = .degrees(displayName: "Longitude", value: value?.longitude, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CLLocationCoordinate2D?, date: Date = Date()) {
        if let value = value {
            $latitude.updateValueIfDifferent(value.latitude, date: date)
            $longitude.updateValueIfDifferent(value.longitude, date: date)
        } else {
            $latitude.update(value: nil, date: date)
            $longitude.update(value: nil, date: date)
        }

        super.update(value: value, date: date)
    }

}
