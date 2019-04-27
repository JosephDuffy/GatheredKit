import Foundation
import CoreLocation

public final class CoordinateValue: Property<CLLocationCoordinate2D, CoordinateFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [
            latitude,
            longitude,
        ]
    }

    var latitude: AngleValue {
        return .degrees(displayName: "Latitude", value: value.latitude, date: date)
    }

    var longitude: AngleValue {
        return .degrees(displayName: "Longitude", value: value.longitude, date: date)
    }

}

public final class OptionalCoordinateValue: OptionalProperty<CLLocationCoordinate2D, CoordinateFormatter>, PropertiesProvider {
    
    public var allProperties: [AnyProperty] {
        return [
            latitude,
            longitude,
        ]
    }
    
    var latitude: OptionalAngleValue {
        return .degrees(displayName: "Latitude", value: value?.latitude, date: date)
    }
    
    var longitude: OptionalAngleValue {
        return .degrees(displayName: "Longitude", value: value?.longitude, date: date)
    }
    
}
