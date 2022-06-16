#if canImport(UIKit)
import Foundation
import UIKit

open class BatteryLevelFormatter: NumberFormatter {
    public override init() {
        super.init()

        numberStyle = .percent
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        numberStyle = .percent
    }

    open override func string(for obj: Any?) -> String? {
        if let number = obj as? Float, number < 0 {
            return "Unknown"
        }

        return super.string(for: obj)
    }
}
#endif
