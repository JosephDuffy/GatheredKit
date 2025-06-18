import AVFoundation
import Foundation

public struct AVCaptureDevicePositionFormatStyle: FormatStyle {
    public func format(_ position: AVCaptureDevice.Position) -> String {
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
}

extension AVCaptureDevice.Position {
    public func formatted<S>(_ format: S) -> S.FormatOutput where Self == S.FormatInput, S : FormatStyle {
        format.format(self)
    }

    public func formatted() -> String {
        formatted(.position)
    }
}

extension FormatStyle where Self == AVCaptureDevicePositionFormatStyle {
    public static var position: AVCaptureDevicePositionFormatStyle {
        AVCaptureDevicePositionFormatStyle()
    }
}
