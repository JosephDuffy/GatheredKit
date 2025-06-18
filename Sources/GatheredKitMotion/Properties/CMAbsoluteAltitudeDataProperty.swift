#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CMAbsoluteAltitudeData>
@available(macOS, unavailable)
@propertyWrapper
public final class CMAbsoluteAltitudeDataProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\CMAbsoluteAltitudeData.altitude, unit: UnitLength.meters)
    public private(set) var altitude: Measurement<UnitLength>

    @PropertyValue(\CMAbsoluteAltitudeData.accuracy, unit: UnitLength.meters)
    public private(set) var accuracy: Measurement<UnitLength>

    @PropertyValue(\CMAbsoluteAltitudeData.precision, unit: UnitLength.meters)
    public private(set) var precision: Measurement<UnitLength>
}
#endif
