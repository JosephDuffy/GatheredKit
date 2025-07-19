import AVFoundation
import Foundation

@available(watchOS, unavailable)
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

@available(watchOS, unavailable)
extension AVCaptureDevice.Position {
    public func formatted<S>(_ format: S) -> S.FormatOutput where Self == S.FormatInput, S : FormatStyle {
        format.format(self)
    }

    public func formatted() -> String {
        formatted(.position)
    }
}

@available(watchOS, unavailable)
extension FormatStyle where Self == AVCaptureDevicePositionFormatStyle {
    public static var position: AVCaptureDevicePositionFormatStyle {
        AVCaptureDevicePositionFormatStyle()
    }
}
