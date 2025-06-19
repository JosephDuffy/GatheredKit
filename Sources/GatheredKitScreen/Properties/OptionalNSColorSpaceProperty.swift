#if os(macOS)
import AppKit
import Combine
import GatheredKit

@UpdatableProperty<NSColorSpace?>
@propertyWrapper
public final class OptionalNSColorSpaceProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\NSColorSpace.colorSpaceModel)
    public private(set) var model: NSColorSpace.Model?
}
#endif
