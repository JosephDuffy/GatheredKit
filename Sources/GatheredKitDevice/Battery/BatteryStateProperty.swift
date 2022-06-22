#if canImport(UIKit)
import GatheredKit
import UIKit

@available(tvOS, unavailable)
public typealias BatteryStateProperty = BasicProperty<UIDevice.BatteryState, BatteryStateFormatter>
#endif
