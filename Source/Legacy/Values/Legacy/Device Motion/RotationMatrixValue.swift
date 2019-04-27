import Foundation
import CoreMotion

public struct RotationMatrixValue: Value, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [m11, m12, m13, m21, m22, m23, m31, m32, m33]
    }

    public var m11: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "m11",
            value: value?.m11,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m12: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "m12",
            value: value?.m12,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m13: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "m13",
            value: value?.m13,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m21: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "m21",
            value: value?.m21,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m22: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "m22",
            value: value?.m22,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m23: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "m23",
            value: value?.m23,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m31: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "m31",
            value: value?.m31,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m32: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "m32",
            value: value?.m32,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var m33: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "m32",
            value: value?.m32,
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public let displayName = "Rotation Matrix"

    public let formattedValue: String? = nil

    public let value: CMRotationMatrix?

    public let date: Date

    public init(value: CMRotationMatrix? = nil, date: Date) {
        self.value = value
        self.date = date
    }

    /**
     Updates `self` to be a new `RotationMatrixValue` instance with the
     updates properties provided

     - parameter value: The new value of the data
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public mutating func update(
        value: CMRotationMatrix,
        date: Date = Date()
    ) {
        self = RotationMatrixValue(value: value, date: date)
    }

}
