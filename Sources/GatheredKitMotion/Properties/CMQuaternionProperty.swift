#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import GatheredKitCore

@propertyWrapper
public final class CMQuaternionProperty: BasicProperty<CMQuaternion, CMQuaternionFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [
            $x,
            $y,
            $z,
            $w,
        ]
    }

    @DoubleProperty
    public private(set) var x: Double

    @DoubleProperty
    public private(set) var y: Double

    @DoubleProperty
    public private(set) var z: Double

    @DoubleProperty
    public private(set) var w: Double

    public override var wrappedValue: CMQuaternion {
        get {
            return super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }

    public override var projectedValue: ReadOnlyProperty<CMQuaternion, CMQuaternionFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CMQuaternion, formatter: CMQuaternionFormatter = CMQuaternionFormatter(), date: Date = Date()) {
        _x = .init(displayName: "x", value: value.x, date: date)
        _y = .init(displayName: "y", value: value.y, date: date)
        _z = .init(displayName: "z", value: value.z, date: date)
        _w = .init(displayName: "w", value: value.z, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CMQuaternion, date: Date = Date()) {
        _x.updateValueIfDifferent(value.x, date: date)
        _y.updateValueIfDifferent(value.y, date: date)
        _z.updateValueIfDifferent(value.z, date: date)
        _w.updateValueIfDifferent(value.z, date: date)

        super.update(value: value, date: date)
    }

}

@propertyWrapper
public final class OptionalCMQuaternionProperty: BasicProperty<CMQuaternion?, CMQuaternionFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [
            $x,
            $y,
            $z,
            $w,
        ]
    }

    @OptionalDoubleProperty
    public private(set) var x: Double?

    @OptionalDoubleProperty
    public private(set) var y: Double?

    @OptionalDoubleProperty
    public private(set) var z: Double?

    @OptionalDoubleProperty
    public private(set) var w: Double?

    public override var wrappedValue: CMQuaternion? {
        get {
            return super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }

    public override var projectedValue: ReadOnlyProperty<CMQuaternion?, CMQuaternionFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CMQuaternion?, formatter: CMQuaternionFormatter = CMQuaternionFormatter(), date: Date = Date()) {
        _x = .init(displayName: "x", value: value?.x, date: date)
        _y = .init(displayName: "y", value: value?.y, date: date)
        _z = .init(displayName: "z", value: value?.z, date: date)
        _w = .init(displayName: "w", value: value?.z, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CMQuaternion?, date: Date = Date()) {
        _x.updateValueIfDifferent(value?.x, date: date)
        _y.updateValueIfDifferent(value?.y, date: date)
        _z.updateValueIfDifferent(value?.z, date: date)
        _w.updateValueIfDifferent(value?.z, date: date)

        super.update(value: value, date: date)
    }

}
#endif
