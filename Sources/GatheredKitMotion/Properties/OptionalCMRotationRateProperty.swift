#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CMRotationRate?>
@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMRotationRateProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\CMRotationRate.x, unit: UnitFrequency.radiansPerSecond)
    public private(set) var x: Measurement<UnitFrequency>?

    @PropertyValue(\CMRotationRate.y, unit: UnitFrequency.radiansPerSecond)
    public private(set) var y: Measurement<UnitFrequency>?

    @PropertyValue(\CMRotationRate.z, unit: UnitFrequency.radiansPerSecond)
    public private(set) var z: Measurement<UnitFrequency>?
}
#endif
