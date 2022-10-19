import AVFoundation
import Foundation

open class ProcessInfoThermalStateFormatter: Formatter {
    public override init() {
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func string(for thermalState: ProcessInfo.ThermalState) -> String {
        switch thermalState {
        case .nominal:
            return NSLocalizedString(
                "thermal-state.nominal",
                bundle: .module,
                comment: ""
            )
        case .fair:
            return NSLocalizedString(
                "thermal-state.fair",
                bundle: .module,
                comment: ""
            )
        case .serious:
            return NSLocalizedString(
                "thermal-state.serious",
                bundle: .module,
                comment: ""
            )
        case .critical:
            return NSLocalizedString(
                "thermal-state.critical",
                bundle: .module,
                comment: ""
            )
        @unknown default:
            return NSLocalizedString(
                "thermal-state.unknown",
                bundle: .module,
                comment: ""
            )
        }
    }

    public override func string(for obj: Any?) -> String? {
        guard let thermalState = obj as? ProcessInfo.ThermalState else { return nil }
        return string(for: thermalState)
    }

    open override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `ProcessInfo.ThermalState` is not a class
        false
    }
}
