import Foundation
import CoreLocation

public struct GeomagnetismValue: Value, ValuesProvider {

    public var allValues: [AnyValue] {
        return [
            x.asAny(),
            y.asAny(),
            z.asAny(),
        ]
    }

    public var x: GenericValue<Double?, NumericNone> {
        return GenericValue<Double?, NumericNone>(
            name: "X Axis",
            backingValue: backingValue?.x,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var y: GenericValue<Double?, NumericNone> {
        return GenericValue<Double?, NumericNone>(
            name: "Y Axis",
            backingValue: backingValue?.y,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var z: GenericValue<Double?, NumericNone> {
        return GenericValue<Double?, NumericNone>(
            name: "Z Axis",
            backingValue: backingValue?.z,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }
    public let name = "Raw Geomagnetism"

    public let unit = Microtesla()

    public let formattedValue: String? = nil

    public let backingValue: CLHeading?

    public let date: Date

    public init(backingValue: CLHeading? = nil, date: Date = Date()) {
        self.backingValue = backingValue
        self.date = date
    }

    /**
     Updates `self` to be a new `GeomagnetismValue` instance with the
     updates values provided

     - parameter backingValue: The new value of the data
     */
    public mutating func update(backingValue: ValueType) {
        self = GeomagnetismValue(backingValue: backingValue, date: backingValue?.timestamp ?? Date())
    }

}
