#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CMAcceleration?>
@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMAccelerationProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\CMAcceleration.x, unit: UnitAcceleration.gravity)
    public private(set) var x: Measurement<UnitAcceleration>?

    @PropertyValue(\CMAcceleration.y, unit: UnitAcceleration.gravity)
    public private(set) var y: Measurement<UnitAcceleration>?

    @PropertyValue(\CMAcceleration.z, unit: UnitAcceleration.gravity)
    public private(set) var z: Measurement<UnitAcceleration>?
}
#endif
