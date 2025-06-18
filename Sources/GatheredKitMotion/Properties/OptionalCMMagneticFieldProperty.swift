#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CMMagneticField?>
@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMMagneticFieldProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\CMMagneticField.x, unit: UnitMagneticField.microTesla)
    public private(set) var x: Measurement<UnitMagneticField>?

    @PropertyValue(\CMMagneticField.y, unit: UnitMagneticField.microTesla)
    public private(set) var y: Measurement<UnitMagneticField>?

    @PropertyValue(\CMMagneticField.z, unit: UnitMagneticField.microTesla)
    public private(set) var z: Measurement<UnitMagneticField>?
}
#endif
