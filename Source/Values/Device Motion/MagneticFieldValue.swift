import Foundation
import CoreMotion

public struct MagneticFieldValue: Value, ValueProvider {

    public var latestValues: [AnyValue] {
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

    public let name = "Magnetic Field (Raw)"

    public let unit = None()

    public let formattedValue: String? = nil

    public let backingValue: CMMagneticField?

    public let date: Date

    public init(backingValue: CMMagneticField?, date: Date) {
        self.backingValue = backingValue
        self.date = date
    }

    /**
     Updates `self` to be a new `CalibratedMagneticFieldValue` instance with the
     updates values provided

     - parameter backingValue: The new value of the data
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public mutating func update(backingValue: ValueType, date: Date = Date()) {
        self = MagneticFieldValue(backingValue: backingValue, date: date)
    }

}
