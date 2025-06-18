#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CMQuaternion?>
@available(macOS, unavailable)
@propertyWrapper
public final class OptionalCMQuaternionProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\CMQuaternion.x)
    public private(set) var x: Double?

    @PropertyValue(\CMQuaternion.y)
    public private(set) var y: Double?

    @PropertyValue(\CMQuaternion.z)
    public private(set) var z: Double?

    @PropertyValue(\CMQuaternion.w)
    public private(set) var w: Double?
}
#endif
