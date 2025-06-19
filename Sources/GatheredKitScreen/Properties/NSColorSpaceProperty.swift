#warning("Compile me and find that the key path is ignored :)")

#if os(macOS)
import AppKit
import Combine
import GatheredKit

@UpdatableProperty<NSColorSpace>
@propertyWrapper
public final class NSColorSpaceProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\NSColorSpace.colorSpaceModel)
    public private(set) var model: NSColorSpace.Model
}
#endif
