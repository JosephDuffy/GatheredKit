#if os(iOS) || os(tvOS)
import GatheredKit
import UIKit

@available(tvOS, unavailable)
public typealias BatteryStateProperty = BasicProperty<UIDevice.BatteryState>
#endif
