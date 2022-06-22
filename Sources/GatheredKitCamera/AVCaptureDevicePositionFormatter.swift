import AVFoundation
import Foundation

@available(macOS 10.7, iOS 4, macCatalyst 14, *)
@available(tvOS, unavailable)
open class AVCaptureDevicePositionFormatter: Formatter {
    public override init() {
        super.init()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func string(for position: AVCaptureDevice.Position) -> String {
        switch position {
        case .front:
            return "Front"
        case .back:
            return "Back"
        case .unspecified:
            return "Unspecified"
        @unknown default:
            return "Unknown"
        }
    }

    public override func string(for obj: Any?) -> String? {
        guard let position = obj as? AVCaptureDevice.Position else { return nil }
        return string(for: position)
    }

    open override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `AVCaptureDevice.Position` is not a class
        false
    }
}
