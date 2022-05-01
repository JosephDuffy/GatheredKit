#if os(macOS)
import AppKit
import GatheredKit

public typealias NSColorSpaceModelProperty = BasicProperty<NSColorSpace.Model, NSColorSpaceModelFormatter>
public typealias OptionalNSColorSpaceModelProperty = BasicProperty<NSColorSpace.Model?, NSColorSpaceModelFormatter>
#endif
