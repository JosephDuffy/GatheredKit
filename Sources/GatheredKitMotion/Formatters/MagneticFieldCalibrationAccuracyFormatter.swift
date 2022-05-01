#if canImport(CoreMotion)
import CoreMotion
import Foundation

public final class MagneticFieldCalibrationAccuracyFormatter: Formatter {
    public func string(for status: CMMagneticFieldCalibrationAccuracy) -> String {
        switch status {
        case .uncalibrated:
            return "Uncalibrated"
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        @unknown default:
            return "Unknown"
        }
    }

    public override func string(for obj: Any?) -> String? {
        guard let status = obj as? CMMagneticFieldCalibrationAccuracy else { return nil }
        return string(for: status)
    }

    public override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        #warning("TODO: Implement")
        fatalError("Unimplemented")
    }
}
#endif
