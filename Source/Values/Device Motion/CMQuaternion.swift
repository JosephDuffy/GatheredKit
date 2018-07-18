import Foundation
import CoreMotion

public struct QuaternionValue: Value, ValuesProvider {

    public var allValues: [AnyValue] {
        return [
            x.asAny(),
            y.asAny(),
            z.asAny(),
            w.asAny(),
        ]
    }

    public var x: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "x",
            backingValue: backingValue?.x,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var y: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "y",
            backingValue: backingValue?.y,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var z: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "z",
            backingValue: backingValue?.z,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var w: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "w",
            backingValue: backingValue?.w,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public let displayName = "Quaterion"

    public let unit = None()

    public let formattedValue: String? = nil

    public let backingValue: CMQuaternion?

    public let date: Date

    public init(backingValue: CMQuaternion? = nil, date: Date) {
        self.backingValue = backingValue
        self.date = date
    }

    /**
     Updates `self` to be a new `RotationRateValue` instance with the
     updates values provided

     - parameter backingValue: The new value of the data
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public mutating func update(backingValue: ValueType, date: Date = Date()) {
        self = QuaternionValue(backingValue: backingValue, date: date)
    }

}
