import Foundation
import CoreMotion

extension GenericValue: ValueProvider where ValueType: CMAttitude {

    public var latestValues: [AnyValue] {
        return [
            roll.asAny(),
            pitch.asAny(),
            yaw.asAny(),
            rotationMatrix.asAny(),
            quaternion.asAny(),
        ]
    }

    public var roll: GenericValue<Double, None> {
        return GenericValue<Double, None>(
            displayName: "Roll",
            value: backingValue.roll,
            unit: None(),
            date: self.date
        )
    }

    public var pitch: GenericValue<Double, None> {
        return GenericValue<Double, None>(
            displayName: "Pitch",
            value: backingValue.pitch,
            unit: None(),
            date: self.date
        )
    }

    public var yaw: GenericValue<Double, None> {
        return GenericValue<Double, None>(
            displayName: "Yaw",
            value: backingValue.yaw,
            unit: None(),
            date: self.date
        )
    }

    public var rotationMatrix: GenericValue<CMRotationMatrix, None> {
        return GenericValue<CMRotationMatrix, None>(
            displayName: "Rotation Matrix",
            value: backingValue.rotationMatrix,
            unit: None(),
            date: self.date
        )
    }

    public var quaternion: GenericValue<CMQuaternion, None> {
        return GenericValue<CMQuaternion, None>(
            displayName: "Quaternion",
            value: backingValue.quaternion,
            unit: None(),
            date: self.date
        )
    }

}

public protocol MagneticField {

    var field: CMMagneticField { get }

    var accuracy: CMMagneticFieldCalibrationAccuracy { get }

}

extension CMCalibratedMagneticField: MagneticField {}

extension GenericValue where ValueType: MagneticField {

    public var latestValues: [AnyValue] {
        return [
            field.asAny(),
            accuracy.asAny(),
        ]
    }

    public var field: GenericValue<CMMagneticField, None> {
        return GenericValue<CMMagneticField, None>(
            displayName: "Field",
            value: backingValue.field,
            unit: None(),
            date: self.date
        )
    }

    public var accuracy: GenericValue<CMMagneticFieldCalibrationAccuracy, None> {
        let formattedValue: String

        switch backingValue.accuracy {
        case .uncalibrated:
            formattedValue = "Uncalibrated"
        case .low:
            formattedValue = "Low"
        case .medium:
            formattedValue = "Medium"
        case .high:
            formattedValue = "High"
        }

        return GenericValue<CMMagneticFieldCalibrationAccuracy, None>(
            displayName: "Accuracy",
            value: backingValue.accuracy,
            formattedValue: formattedValue,
            unit: None(),
            date: self.date
        )
    }

}

public protocol ThreeDimentionAxes {

    var x: Double { get }

    var y: Double { get }

    var z: Double { get }

}

extension CMRotationRate: ThreeDimentionAxes {}
extension CMAcceleration: ThreeDimentionAxes {}
extension CMMagneticField: ThreeDimentionAxes {}

extension GenericValue where ValueType: ThreeDimentionAxes {

    public var latestValues: [AnyValue] {
        return [
            x.asAny(),
            y.asAny(),
            z.asAny(),
        ]
    }

    public var x: GenericValue<Double, None> {
        return GenericValue<Double, None>(
            displayName: "X Axis",
            value: backingValue.x,
            unit: None(),
            date: self.date
        )
    }

    public var y: GenericValue<Double, None> {
        return GenericValue<Double, None>(
            displayName: "Y Axis",
            value: backingValue.y,
            unit: None(),
            date: self.date
        )
    }

    public var z: GenericValue<Double, None> {
        return GenericValue<Double, None>(
            displayName: "Z Axis",
            value: backingValue.z,
            unit: None(),
            date: self.date
        )
    }

}
