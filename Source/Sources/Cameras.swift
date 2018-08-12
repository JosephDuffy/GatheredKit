import Foundation
import AVFoundation

public final class Cameras: Source, ValuesProvider {

    public static let availability: SourceAvailability = .available

    public static let name = "Cameras"

    public let front: GenericUnitlessValue<Camera?>
    public let back: GenericUnitlessValue<Camera?>

    public var allValues: [Value] {
        return [front, back]
    }

    public init() {
        if let frontCaptureDevice = AVCaptureDevice.frontCaptureDevice() {
            let camera = Camera(captureDevice: frontCaptureDevice)
            front = GenericUnitlessValue(
                displayName: frontCaptureDevice.localizedName,
                backingValue: camera
            )
        } else {
            front = GenericUnitlessValue(displayName: "Front Camera")
        }

        if let backCaptureDevice = AVCaptureDevice.backCaptureDevice() {
            let camera = Camera(captureDevice: backCaptureDevice)
            back = GenericUnitlessValue(
                displayName: backCaptureDevice.localizedName,
                backingValue: camera
            )
        } else {
            back = GenericUnitlessValue(displayName: "Back Camera")
        }
    }

}

public extension Cameras {

    struct Camera: ValuesProvider {

        public let uniqueID: GenericUnitlessValue<String>
        public let modelID: GenericUnitlessValue<String>
        // TODO: Add unit
        public let highestStillImageResolution: GenericUnitlessValue<CMVideoDimensions?>
        public let supportsHDRVideo: GenericValue<Bool?, Boolean>
        // TODO: Add unit
        public let highestVideoResolution: GenericUnitlessValue<CMVideoDimensions?>
        public let maximumFramerate: GenericUnitlessValue<Float64?>

        public let allValues: [Value]

        public init(captureDevice: AVCaptureDevice) {
            uniqueID = GenericUnitlessValue(
                displayName: "Unique ID",
                backingValue: captureDevice.uniqueID
            )
            modelID = GenericUnitlessValue(
                displayName: "Model ID",
                backingValue: captureDevice.modelID
            )

            let metadata = FormatsMetadata(formats: captureDevice.formats)

            highestStillImageResolution = GenericUnitlessValue(
                displayName: "Highest Still Image Resolution",
                backingValue: metadata.highestStillImageResolution,
                formattedValue: metadata.highestStillImageResolution?.formattedString ?? "Unknown"
            )

            supportsHDRVideo = GenericValue(
                displayName: "Supports HDR Video",
                backingValue: metadata.supportsHDRVideo,
                formattedValue: metadata.supportsHDRVideo == nil ? nil : "Unknown",
                unit: Boolean(trueString: "Yes", falseString: "No")
            )

            highestVideoResolution = GenericUnitlessValue(
                displayName: "Highest Video Resolution",
                backingValue: metadata.highestVideoResolution,
                formattedValue: metadata.highestVideoResolution?.formattedString ?? "Unknown"
            )

            let formattedMaximumFramerate: String
            if let maximumFramerate = metadata.maximumFramerate {
                formattedMaximumFramerate = "\(maximumFramerate)"
            } else {
                formattedMaximumFramerate = "Unknown"
            }

            maximumFramerate = GenericUnitlessValue(
                displayName: "Maximum Framerate",
                backingValue: metadata.maximumFramerate,
                formattedValue: formattedMaximumFramerate
            )

            allValues = [
                uniqueID,
                modelID,
                highestStillImageResolution,
                supportsHDRVideo,
                highestVideoResolution,
                maximumFramerate
            ]
        }
    }

}

private extension Cameras.Camera {

    struct FormatsMetadata {
        let highestStillImageResolution: CMVideoDimensions?
        let supportsHDRVideo: Bool?
        let highestVideoResolution: CMVideoDimensions?
        let maximumFramerate: Float64?

        init(formats: [AVCaptureDevice.Format]) {
            var highestStillImageResolution: CMVideoDimensions?
            var supportsHDRVideo: Bool?
            var highestVideoResolution: CMVideoDimensions?
            var maximumFramerate: Float64?

            for format in formats {
                if
                    highestStillImageResolution == nil ||
                    format.highResolutionStillImageDimensions.totalPixels >
                        highestStillImageResolution?.totalPixels ?? 0
                {
                    highestStillImageResolution = format.highResolutionStillImageDimensions
                }

                let videoResolution = CMVideoFormatDescriptionGetDimensions(format.formatDescription)

                if
                    highestVideoResolution == nil ||
                    videoResolution.totalPixels >
                        highestVideoResolution?.totalPixels ?? 0
                {
                    highestVideoResolution = videoResolution
                }

                for frameRateRange in format.videoSupportedFrameRateRanges {
                    if
                        maximumFramerate == nil ||
                        frameRateRange.maxFrameRate > maximumFramerate ?? 0
                    {
                        maximumFramerate = frameRateRange.maxFrameRate
                    }
                }

                if #available(iOS 10, *) {
                    if format.supportedColorSpaces.contains(.P3_D65) {
                        supportsHDRVideo = true
                    } else if supportsHDRVideo == nil {
                        supportsHDRVideo = false
                    }
                }
            }

            self.highestStillImageResolution = highestStillImageResolution
            self.supportsHDRVideo = supportsHDRVideo
            self.highestVideoResolution = highestVideoResolution
            self.maximumFramerate = maximumFramerate
        }
    }

}

private extension AVCaptureDevice {

    static func frontCaptureDevice() -> AVCaptureDevice? {
        if #available(iOS 10.0, *) {
            return defaultDevice(position: .front)
        } else {
            let devices = AVCaptureDevice.devices()
            return devices.first { $0.position == .front }
        }
    }

    static func backCaptureDevice() -> AVCaptureDevice? {
        if #available(iOS 10.0, *) {
            return defaultDevice(position: .back)
        } else {
            let devices = AVCaptureDevice.devices()
            return devices.first { $0.position == .back }
        }
    }

    @available(iOS 10.0, *)
    private static func defaultDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceTypes: [AVCaptureDevice.DeviceType]
        if #available(iOS 11.1, *) {
            deviceTypes = [
                .builtInWideAngleCamera,
                .builtInTelephotoCamera,
                .builtInDualCamera,
                .builtInTrueDepthCamera,
            ]
        } else if #available(iOS 10.2, *) {
            deviceTypes = [
                .builtInWideAngleCamera,
                .builtInTelephotoCamera,
                .builtInDualCamera,
            ]
        } else {
            deviceTypes = [
                .builtInWideAngleCamera,
                .builtInTelephotoCamera,
            ]
        }

        for deviceType in deviceTypes {
            if let device = AVCaptureDevice.default(deviceType, for: nil, position: position) {
                return device
            }
        }

        return nil
    }

}

private extension CMVideoDimensions {

    var totalPixels: Int32 {
        return width * height
    }

    var formattedString: String {
        return "\(width) x \(height)"
    }

}
