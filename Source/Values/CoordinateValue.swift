import Foundation
import CoreLocation

public final class CoordinateValue: Value<CLLocationCoordinate2D, CoordinateFormatter>, ValuesProvider {

    public var allValues: [AnyValue] {
        return [
            latitude,
            longitude,
        ]
    }

    var latitude: AngleValue {
        return .degrees(displayName: "Latitude", value: backingValue.latitude, date: date)
    }

    var longitude: AngleValue {
        return .degrees(displayName: "Longitude", value: backingValue.longitude, date: date)
    }

}

public final class OptionalCoordinateValue: OptionalValue<CLLocationCoordinate2D, CoordinateFormatter>, ValuesProvider {
    
    public var allValues: [AnyValue] {
        return [
            latitude,
            longitude,
        ]
    }
    
    var latitude: OptionalAngleValue {
        return .degrees(displayName: "Latitude", value: backingValue?.latitude, date: date)
    }
    
    var longitude: OptionalAngleValue {
        return .degrees(displayName: "Longitude", value: backingValue?.longitude, date: date)
    }
    
}
