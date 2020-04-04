#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import GatheredKitCore

// TODO: Add rotationMatrix

@propertyWrapper
public final class CMAttitudeProperty: BasicProperty<CMAttitude, CMAttitudeFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [$roll, $pitch, $yaw, $quaternion]
    }

    @AngleProperty
    public private(set) var roll: Measurement<UnitAngle>

    @AngleProperty
    public private(set) var pitch: Measurement<UnitAngle>

    @AngleProperty
    public private(set) var yaw: Measurement<UnitAngle>

    @CMQuaternionProperty
    public private(set) var quaternion: CMQuaternion

    public override var wrappedValue: CMAttitude {
           get {
               return super.wrappedValue
           }
           set {
               super.wrappedValue = newValue
           }
       }

    public override var projectedValue: ReadOnlyProperty<CMAttitude, CMAttitudeFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CMAttitude, formatter: CMAttitudeFormatter = CMAttitudeFormatter(), date: Date = Date()) {
        _roll = .radians(displayName: "Roll", value: value.roll, date: date)
        _pitch = .radians(displayName: "Pitch", value: value.pitch, date: date)
        _yaw = .radians(displayName: "Yaw", value: value.yaw, date: date)
        _quaternion = .init(displayName: "Quaternion", value: value.quaternion, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CMAttitude, date: Date = Date()) {
        _roll.updateValueIfDifferent(value.roll, date: date)
        _pitch.updateValueIfDifferent(value.pitch, date: date)
        _yaw.updateValueIfDifferent(value.yaw, date: date)
        _quaternion.update(value: value.quaternion, date: date)

        super.update(value: value, date: date)
    }

}

@propertyWrapper
public final class OptionalCMAttitudeProperty: BasicProperty<CMAttitude?, CMAttitudeFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [$roll, $pitch, $yaw, $quaternion]
    }

    @OptionalAngleProperty
    public private(set) var roll: Measurement<UnitAngle>?

    @OptionalAngleProperty
    public private(set) var pitch: Measurement<UnitAngle>?

    @OptionalAngleProperty
    public private(set) var yaw: Measurement<UnitAngle>?

    @OptionalCMQuaternionProperty
    public private(set) var quaternion: CMQuaternion?

    public override var wrappedValue: CMAttitude? {
           get {
               return super.wrappedValue
           }
           set {
               super.wrappedValue = newValue
           }
       }

    public override var projectedValue: ReadOnlyProperty<CMAttitude?, CMAttitudeFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CMAttitude? = nil, formatter: CMAttitudeFormatter = CMAttitudeFormatter(), date: Date = Date()) {
        _roll = .radians(displayName: "Roll", value: value?.roll, date: date)
        _pitch = .radians(displayName: "Pitch", value: value?.pitch, date: date)
        _yaw = .radians(displayName: "Yaw", value: value?.yaw, date: date)
        _quaternion = .init(displayName: "Quaternion", value: value?.quaternion, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CMAttitude?, date: Date = Date()) {
        _roll.updateValueIfDifferent(measuredValue: value?.roll, date: date)
        _pitch.updateValueIfDifferent(measuredValue: value?.pitch, date: date)
        _yaw.updateValueIfDifferent(measuredValue: value?.yaw, date: date)
        _quaternion.update(value: value?.quaternion, date: date)

        super.update(value: value, date: date)
    }

}
#endif
