import Foundation
import CoreMotion

public struct RotationMatrixValue: TypedValue, ValuesProvider {

    public var allValues: [Value] {
        return [
            m11,
            m12,
            m13,
            m21,
            m22,
            m23,
            m31,
            m32,
            m33,
        ]
    }

    public var m11: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "m11",
            backingValue: backingValue?.m11,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m12: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "m12",
            backingValue: backingValue?.m12,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m13: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "m13",
            backingValue: backingValue?.m13,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m21: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "m21",
            backingValue: backingValue?.m21,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m22: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "m22",
            backingValue: backingValue?.m22,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m23: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "m23",
            backingValue: backingValue?.m23,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m31: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "m31",
            backingValue: backingValue?.m31,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m32: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "m32",
            backingValue: backingValue?.m32,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m33: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "m32",
            backingValue: backingValue?.m32,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public let displayName = "Rotation Matrix"

    public let formattedValue: String? = nil

    public let backingValue: CMRotationMatrix?

    public let date: Date

    public init(backingValue: CMRotationMatrix? = nil, date: Date) {
        self.backingValue = backingValue
        self.date = date
    }

    /**
     Updates `self` to be a new `RotationMatrixValue` instance with the
     updates values provided

     - parameter backingValue: The new value of the data
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public mutating func update(backingValue: CMRotationMatrix, date: Date = Date()) {
        self = RotationMatrixValue(backingValue: backingValue, date: date)
    }

}
