import Foundation
import CoreLocation

public struct GeomagnetismValue: Value, UnitProvider, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [x, y, z]
    }

    public var x: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "X Axis",
            value: value?.x,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var y: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "Y Axis",
            value: value?.y,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var z: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "Z Axis",
            value: value?.z,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }
    public let displayName = "Raw Geomagnetism"

    public let unit = Microtesla()

    public let formattedValue: String? = nil

    public let value: CLHeading?

    public let date: Date

    public init(value: CLHeading? = nil, date: Date = Date()) {
        self.value = value
        self.date = date
    }

    /**
     Updates `self` to be a new `GeomagnetismValue` instance with the
     updates properties provided

     - parameter value: The new value of the data
     */
    public mutating func update(value: ValueType) {
        self = GeomagnetismValue(
            value: value,
            date: value?.timestamp ?? Date()
        )
    }

}
