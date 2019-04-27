import Foundation
import CoreMotion

public struct QuaternionValue: Value, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [x, y, z, w]
    }

    public var x: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "x",
            value: value?.x,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var y: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "y",
            value: value?.y,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var z: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "z",
            value: value?.z,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var w: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "w",
            value: value?.w,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public let displayName = "Quaterion"

    public let formattedValue: String? = nil

    public let value: CMQuaternion?

    public let date: Date

    public init(value: CMQuaternion? = nil, date: Date) {
        self.value = value
        self.date = date
    }

    /**
     Updates `self` to be a new `RotationRateValue` instance with the
     updates properties provided

     - parameter value: The new value of the data
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public mutating func update(value: ValueType, date: Date = Date()) {
        self = QuaternionValue(value: value, date: date)
    }

}
