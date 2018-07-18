import Foundation
import CoreMotion

public struct AccelerationValue: Value, ValuesProvider {

    public var allValues: [AnyValue] {
        return [
            x.asAny(),
            y.asAny(),
            z.asAny(),
        ]
    }

    public var x: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "X Axis",
            backingValue: backingValue?.x,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var y: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "Y Axis",
            backingValue: backingValue?.y,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var z: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "Z Axis",
            backingValue: backingValue?.z,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public let displayName: String

    public let unit = None()

    public let formattedValue: String? = nil

    public let backingValue: CMAcceleration?

    public let date: Date

    public init(name: String, backingValue: CMAcceleration? = nil, date: Date) {
        self.displayName = name
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
        self = AccelerationValue(name: displayName, backingValue: backingValue, date: date)
    }

}
