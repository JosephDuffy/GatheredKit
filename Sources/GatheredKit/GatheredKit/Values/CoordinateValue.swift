import Foundation
import CoreLocation

public final class CoordinateValue: Property<CLLocationCoordinate2D, CoordinateFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [
            latitude,
            longitude,
        ]
    }

    public let latitude: AngleValue

    public let longitude: AngleValue
    
    public required init(displayName: String, value: CLLocationCoordinate2D, formatter: CoordinateFormatter = CoordinateFormatter(), date: Date = Date()) {
        latitude = .degrees(displayName: "Latitude", value: value.latitude, date: date)
        longitude = .degrees(displayName: "Longitude", value: value.longitude, date: date)
        
        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }
    
    public override func update(value: CLLocationCoordinate2D, date: Date = Date()) {
        latitude.update(value: value.latitude, date: date)
        longitude.update(value: value.longitude, date: date)
        
        super.update(value: value, date: date)
    }

}

public final class OptionalCoordinateValue: OptionalProperty<CLLocationCoordinate2D, CoordinateFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [
            latitude,
            longitude,
        ]
    }

    public let latitude: OptionalAngleValue

    public let longitude: OptionalAngleValue
    
    public required init(displayName: String, value: CLLocationCoordinate2D? = nil, formatter: CoordinateFormatter = CoordinateFormatter(), date: Date = Date()) {
        latitude = .degrees(displayName: "Latitude", value: value?.latitude, date: date)
        longitude = .degrees(displayName: "Longitude", value: value?.longitude, date: date)
        
        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }
    
    public override func update(value: CLLocationCoordinate2D?, date: Date = Date()) {
        if let value = value {
            latitude.update(value: value.latitude, date: date)
            longitude.update(value: value.longitude, date: date)
        } else {
            latitude.update(value: nil, date: date)
            longitude.update(value: nil, date: date)
        }
        
        super.update(value: value, date: date)
    }

}
