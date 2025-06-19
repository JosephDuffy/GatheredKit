import CoreGraphics
import Combine
import Foundation
import GatheredKit
import GatheredKitMacros

// TODO: Enable passing in unit to init generated via macro

@UpdatableProperty<CGSize>
@propertyWrapper
public final class ResolutionPixelsProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\CGSize.width, unit: UnitResolution.pixels)
    public private(set) var width: Measurement<UnitResolution>

    @PropertyValue(\CGSize.height, unit: UnitResolution.pixels)
    public private(set) var height: Measurement<UnitResolution>
}
