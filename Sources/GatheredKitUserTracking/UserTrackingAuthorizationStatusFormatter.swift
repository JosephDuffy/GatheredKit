#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
import Foundation

@available(macOS 11, iOS 14, tvOS 14, *)
open class UserTrackingAuthorizationStatusFormatter: Formatter {
    public override init() {
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func string(for status: ATTrackingManager.AuthorizationStatus) -> String {
        switch status {
        case .authorized:
            return "Authorised"
        case .denied:
            return "Denied"
        case .notDetermined:
            return "Not Determined"
        case .restricted:
            return "Restricted"
        @unknown default:
            return "Unknown"
        }
    }

    public override func string(for obj: Any?) -> String? {
        guard let status = obj as? ATTrackingManager.AuthorizationStatus else { return nil }
        return string(for: status)
    }

    open override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `ATTrackingManager.AuthorizationStatus` is not a class
        false
    }
}
#endif
