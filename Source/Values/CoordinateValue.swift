import Foundation
import CoreLocation

public struct CoordinateValue: Value, ValuesProvider {

    public var allValues: [AnyValue] {
        return [
            latitude.asAny(),
            longitude.asAny(),
        ]
    }

    public let latitude: GenericValue<CLLocationDegrees?, NumericNone>

    public let longitude: GenericValue<CLLocationDegrees?, NumericNone>

    public let displayName = "Coordinate"

    public let unit = None()

    public let formattedValue: String? = nil

    public let backingValue: CLLocationCoordinate2D?

    public let date: Date

    public init(backingValue: CLLocationCoordinate2D? = nil, date: Date = Date()) {
        self.backingValue = backingValue
        self.date = date
        latitude = GenericValue(
            displayName: "Latitude",
            backingValue: backingValue?.latitude,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
        longitude = GenericValue(
            displayName: "Longitude",
            backingValue: backingValue?.longitude,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    /**
     Updates `self` to be a new `CoordinateValue` instance with the
     backing value provided

     - parameter backingValue: The new backing value
     */
    public mutating func update(backingValue: ValueType, date: Date = Date()) {
        self = CoordinateValue(backingValue: backingValue, date: date)
    }

}
