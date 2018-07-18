import Foundation
import CoreMotion

public struct CalibratedMagneticFieldValue: Value, ValuesProvider {

    public var allValues: [AnyValue] {
        return [
            x.asAny(),
            y.asAny(),
            z.asAny(),
            accuracy.asAny(),
        ]
    }

    public var accuracy: GenericValue<CMMagneticFieldCalibrationAccuracy?, None> {
        let formattedValue: String?

        switch backingValue?.accuracy {
        case .uncalibrated?:
            formattedValue = "Uncalibrated"
        case .low?:
            formattedValue = "Low"
        case .medium?:
            formattedValue = "Medium"
        case .high?:
            formattedValue = "High"
        case nil:
            formattedValue = nil
        }

        return GenericValue(
            displayName: "Accuracy",
            backingValue: backingValue?.accuracy,
            formattedValue: formattedValue,
            date: date
        )
    }

    public var x: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "X Axis",
            backingValue: backingValue?.field.x,
            formattedValue: self.formattedValue(for: backingValue?.field.x),
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var y: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "Y Axis",
            backingValue: backingValue?.field.y,
            formattedValue: self.formattedValue(for: backingValue?.field.y),
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var z: GenericValue<Double?, NumericNone> {
        return GenericValue(
            displayName: "Z Axis",
            backingValue: backingValue?.field.z,
            formattedValue: self.formattedValue(for: backingValue?.field.z),
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public let displayName = "Magnetic Field (Calibrated)"

    public let unit = None()

    public let formattedValue: String? = nil

    public let backingValue: CMCalibratedMagneticField?

    public let date: Date

    public init(backingValue: CMCalibratedMagneticField? = nil, date: Date) {
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
        self = CalibratedMagneticFieldValue(backingValue: backingValue, date: date)
    }

    private func formattedValue(for value: Any?) -> String? {
        if value == nil {
            return "nil"
        } else {
            switch backingValue?.accuracy {
            case .uncalibrated?:
                return "Unknown"
            case nil:
                return "nil"
            default:
                return nil
            }
        }
    }

}
