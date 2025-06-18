#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CMAttitude>
@available(macOS, unavailable)
@propertyWrapper
public final class CMAttitudeProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\CMAttitude.roll, unit: UnitAngle.radians)
    public private(set) var roll: Measurement<UnitAngle>

    @PropertyValue(\CMAttitude.pitch, unit: UnitAngle.radians)
    public private(set) var pitch: Measurement<UnitAngle>

    @PropertyValue(\CMAttitude.yaw, unit: UnitAngle.radians)
    public private(set) var yaw: Measurement<UnitAngle>

    @ChildProperty(\CMAttitude.quaternion, propertyType: CMQuaternionProperty.self)
    public private(set) var quaternion: CMQuaternion

    @ChildProperty(\CMAttitude.rotationMatrix, propertyType: CMRotationMatrixProperty.self)
    public private(set) var rotationMatrix: CMRotationMatrix
}
#endif
