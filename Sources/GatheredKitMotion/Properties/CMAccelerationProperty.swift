#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import GatheredKitCore

@propertyWrapper
public final class CMAccelerationProperty: BasicProperty<CMAcceleration, CMAccelerationFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [$x, $y, $z]
    }

    @AccelerationProperty
    public private(set) var x: Measurement<UnitAcceleration>

    @AccelerationProperty
    public private(set) var y: Measurement<UnitAcceleration>

    @AccelerationProperty
    public private(set) var z: Measurement<UnitAcceleration>

    public override var wrappedValue: CMAcceleration {
           get {
               return super.wrappedValue
           }
           set {
               super.wrappedValue = newValue
           }
       }

    public override var projectedValue: ReadOnlyProperty<CMAcceleration, CMAccelerationFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CMAcceleration, formatter: CMAccelerationFormatter = CMAccelerationFormatter(), date: Date = Date()) {
        _x = .gravity(displayName: "x", value: value.x, date: date)
        _y = .gravity(displayName: "y", value: value.y, date: date)
        _z = .gravity(displayName: "z", value: value.z, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CMAcceleration, date: Date = Date()) {
        _x.updateValueIfDifferent(value.x, date: date)
        _y.updateValueIfDifferent(value.y, date: date)
        _z.updateValueIfDifferent(value.z, date: date)

        super.update(value: value, date: date)
    }

}

@propertyWrapper
public final class OptionalCMAccelerationProperty: BasicProperty<CMAcceleration?, CMAccelerationFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [$x, $y, $z]
    }

    @OptionalAccelerationProperty
    public var x: Measurement<UnitAcceleration>?

    @OptionalAccelerationProperty
    public var y: Measurement<UnitAcceleration>?

    @OptionalAccelerationProperty
    public var z: Measurement<UnitAcceleration>?

    public override var wrappedValue: CMAcceleration? {
        get {
            return super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }

    public override var projectedValue: ReadOnlyProperty<CMAcceleration?, CMAccelerationFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CMAcceleration? = nil, formatter: CMAccelerationFormatter = CMAccelerationFormatter(), date: Date = Date()) {
        _x = .gravity(displayName: "x", value: value?.x, date: date)
        _y = .gravity(displayName: "y", value: value?.y, date: date)
        _z = .gravity(displayName: "z", value: value?.z, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CMAcceleration?, date: Date = Date()) {
        _x.updateValueIfDifferent(measuredValue: value?.x, date: date)
        _y.updateValueIfDifferent(measuredValue: value?.y, date: date)
        _z.updateValueIfDifferent(measuredValue: value?.z, date: date)

        super.update(value: value, date: date)
    }

}
#endif
