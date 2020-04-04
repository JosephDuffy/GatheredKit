#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import GatheredKitCore

@propertyWrapper
public final class CMRotationRateProperty: BasicProperty<CMRotationRate, CMRotationRateFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [$x, $y, $z]
    }

    @FrequencyProperty
    public private(set) var x: Measurement<UnitFrequency>

    @FrequencyProperty
    public private(set) var y: Measurement<UnitFrequency>

    @FrequencyProperty
    public private(set) var z: Measurement<UnitFrequency>

    public override var wrappedValue: CMRotationRate {
        get {
            return super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }

    public override var projectedValue: ReadOnlyProperty<CMRotationRate, CMRotationRateFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CMRotationRate, formatter: CMRotationRateFormatter = CMRotationRateFormatter(), date: Date = Date()) {
        _x = .radiansPerSecond(displayName: "x", value: value.x, date: date)
        _y = .radiansPerSecond(displayName: "y", value: value.y, date: date)
        _z = .radiansPerSecond(displayName: "z", value: value.z, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CMRotationRate, date: Date = Date()) {
        _x.updateValueIfDifferent(value.x, date: date)
        _y.updateValueIfDifferent(value.y, date: date)
        _z.updateValueIfDifferent(value.z, date: date)

        super.update(value: value, date: date)
    }

}
@propertyWrapper
public final class OptionalCMRotationRateProperty: BasicProperty<CMRotationRate?, CMRotationRateFormatter>, PropertiesProvider {

    public var allProperties: [AnyProperty] {
        return [$x, $y, $z]
    }

    @OptionalFrequencyProperty
    public private(set) var x: Measurement<UnitFrequency>?

    @OptionalFrequencyProperty
    public private(set) var y: Measurement<UnitFrequency>?

    @OptionalFrequencyProperty
    public private(set) var z: Measurement<UnitFrequency>?

    public override var wrappedValue: CMRotationRate? {
        get {
            return super.wrappedValue
        }
        set {
            super.wrappedValue = newValue
        }
    }

    public override var projectedValue: ReadOnlyProperty<CMRotationRate?, CMRotationRateFormatter> { return super.projectedValue }

    public required init(displayName: String, value: CMRotationRate? = nil, formatter: CMRotationRateFormatter = CMRotationRateFormatter(), date: Date = Date()) {
        _x = .radiansPerSecond(displayName: "x", value: value?.x, date: date)
        _y = .radiansPerSecond(displayName: "y", value: value?.y, date: date)
        _z = .radiansPerSecond(displayName: "z", value: value?.z, date: date)

        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

    public override func update(value: CMRotationRate?, date: Date = Date()) {
        _x.updateValueIfDifferent(measuredValue: value?.x, date: date)
        _y.updateValueIfDifferent(measuredValue: value?.y, date: date)
        _z.updateValueIfDifferent(measuredValue: value?.z, date: date)

        super.update(value: value, date: date)
    }

}
#endif
