import Foundation
import CoreMotion

public struct CalibratedMagneticFieldValue: Value, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [x, y, z, accuracy]
    }

    public var accuracy: GenericUnitlessProperty<CMMagneticFieldCalibrationAccuracy?> {
        let formattedValue: String?

        switch value?.accuracy {
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

        return GenericUnitlessValue(
            displayName: "Accuracy",
            value: value?.accuracy,
            formattedValue: formattedValue,
            date: date
        )
    }

    public var x: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "X Axis",
            value: value?.field.x,
            formattedValue: self.formattedValue(for: value?.field.x),
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var y: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "Y Axis",
            value: value?.field.y,
            formattedValue: self.formattedValue(for: value?.field.y),
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public var z: GenericProperty<Double?, NumericNone> {
        return GenericValue(
            displayName: "Z Axis",
            value: value?.field.z,
            formattedValue: self.formattedValue(for: value?.field.z),
            unit: NumericNone(maximumFractionDigits: 20),
            date: date
        )
    }

    public let displayName = "Magnetic Field (Calibrated)"

    public let formattedValue: String? = nil

    public let value: CMCalibratedMagneticField?

    public let date: Date

    public init(value: CMCalibratedMagneticField? = nil, date: Date) {
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
        self = CalibratedMagneticFieldValue(
            value: value,
            date: date
        )
    }

    private func formattedValue(for value: Any?) -> String? {
        if value == nil {
            return "nil"
        } else {
            switch value?.accuracy {
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
