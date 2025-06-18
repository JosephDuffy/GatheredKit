#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CMRotationMatrix>
@available(macOS, unavailable)
@propertyWrapper
public final class CMRotationMatrixProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\CMRotationMatrix.m11)
    public private(set) var m11: Double

    @PropertyValue(\CMRotationMatrix.m12)
    public private(set) var m12: Double

    @PropertyValue(\CMRotationMatrix.m13)
    public private(set) var m13: Double

    @PropertyValue(\CMRotationMatrix.m21)
    public private(set) var m21: Double

    @PropertyValue(\CMRotationMatrix.m22)
    public private(set) var m22: Double

    @PropertyValue(\CMRotationMatrix.m23)
    public private(set) var m23: Double

    @PropertyValue(\CMRotationMatrix.m31)
    public private(set) var m31: Double

    @PropertyValue(\CMRotationMatrix.m32)
    public private(set) var m32: Double

    @PropertyValue(\CMRotationMatrix.m33)
    public private(set) var m33: Double
}
#endif
