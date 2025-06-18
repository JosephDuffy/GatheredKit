#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CMCalibratedMagneticField?>
@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMCalibratedMagneticFieldProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\CMCalibratedMagneticField.accuracy)
    public private(set) var accuracy: CMMagneticFieldCalibrationAccuracy?

    @ChildProperty(
        \CMCalibratedMagneticField.field,
         propertyType: OptionalCMMagneticFieldProperty.self
    )
    public private(set) var field: CMMagneticField?
}
#endif
