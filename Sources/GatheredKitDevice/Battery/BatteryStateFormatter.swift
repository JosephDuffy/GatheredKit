#if canImport(UIKit)
import Foundation
import UIKit

@available(tvOS, unavailable)
open class BatteryStateFormatter: Formatter {
    public override init() {
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func string(for batteryState: UIDevice.BatteryState) -> String {
        switch batteryState {
        case .unknown:
            return "Unknown"
        case .unplugged:
            return "Unplugged"
        case .charging:
            return "Charging"
        case .full:
            return "Full"
        @unknown default:
            return "Unknown"
        }
    }

    public override func string(for obj: Any?) -> String? {
        guard let state = obj as? UIDevice.BatteryState else { return nil }
        return string(for: state)
    }

    open override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `UIDevice.BatteryState` is not a class
        false
    }
}
#endif
