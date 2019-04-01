import Foundation
import CoreLocation

public typealias CoordinateValue = Value<CLLocationCoordinate2D, CoordinateFormatter>
public typealias OptionalCoordinateValue = Value<CLLocationCoordinate2D?, CoordinateFormatter>

extension Value where ValueType == CLLocationCoordinate2D {

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

extension Value where ValueType == CLLocationCoordinate2D? {

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
