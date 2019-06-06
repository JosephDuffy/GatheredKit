import Foundation
import CoreMotion

public struct MagneticFieldValue: Value, PropertiesProvider {

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

    public let displayName = "Magnetic Field (Raw)"

    public let formattedValue: String? = nil

    public let value: CMMagneticField?

    public let date: Date

    public init(value: CMMagneticField? = nil, date: Date) {
        self.value = value
        self.date = date
    }

    /**
     Updates `self` to be a new `CalibratedMagneticFieldValue` instance with the
     updates properties provided

     - parameter value: The new value of the data
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public mutating func update(value: ValueType, date: Date = Date()) {
        self = MagneticFieldValue(value: value, date: date)
    }

}
