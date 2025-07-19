#if os(macOS)
import AppKit
import Combine
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<NSColorSpace?>
@propertyWrapper
public final class OptionalNSColorSpaceProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\NSColorSpace.colorSpaceModel)
    public private(set) var model: NSColorSpace.Model?
}
#endif
