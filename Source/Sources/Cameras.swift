import Foundation
import AVFoundation

public final class Cameras: Source, ValuesProvider {

    public struct Camera: ValuesProvider {

        public let uniqueID: GenericValue<String, None>
        public let modelID: GenericValue<String, None>
        public let highestStillImageResolution: GenericValue<CMVideoDimensions?, None>
        public let supportsHDRVideo: GenericValue<Bool?, Boolean>
        public let highestVideoResolution: GenericValue<CMVideoDimensions?, None>
        public let maximumFramerate: GenericValue<Float64?, None>

        public let allValues: [AnyValue]

        public init(captureDevice: AVCaptureDevice) {
            uniqueID = GenericValue(displayName: "Unique ID", backingValue: captureDevice.uniqueID)
            modelID = GenericValue(displayName: "Model ID", backingValue: captureDevice.modelID)

            var highestStillImageResolution: CMVideoDimensions?
            var supportsHDRVideo: Bool?
            var highestVideoResolution: CMVideoDimensions?
            var maximumFramerate: Float64?

            for format in captureDevice.formats {
                if highestStillImageResolution == nil || format.highResolutionStillImageDimensions.totalPixels > highestStillImageResolution?.totalPixels ?? 0 {
                    highestStillImageResolution = format.highResolutionStillImageDimensions
                }

                let videoResolution = CMVideoFormatDescriptionGetDimensions(format.formatDescription)

                if highestVideoResolution == nil || videoResolution.totalPixels > highestVideoResolution?.totalPixels ?? 0 {
                    highestVideoResolution = videoResolution
                }

                for frameRateRange in format.videoSupportedFrameRateRanges {
                    if maximumFramerate == nil || frameRateRange.maxFrameRate > maximumFramerate ?? 0 {
                        maximumFramerate = frameRateRange.maxFrameRate
                    }
                }

                if #available(iOS 10, *) {
                    if format.supportedColorSpaces.contains(AVCaptureColorSpace.P3_D65) {
                        supportsHDRVideo = true
                    } else if supportsHDRVideo == nil {
                        supportsHDRVideo = false
                    }
                }
            }

            self.highestStillImageResolution = GenericValue(
                displayName: "Highest Still Image Resolution",
                backingValue: highestStillImageResolution,
                formattedValue: highestStillImageResolution?.formattedString ?? "Unknown"
            )

            self.supportsHDRVideo = GenericValue(
                displayName: "Supports HDR Video",
                backingValue: supportsHDRVideo,
                formattedValue: supportsHDRVideo == nil ? nil : "Unknown",
                unit: Boolean(trueString: "Yes", falseString: "No")
            )

            self.highestVideoResolution = GenericValue(
                displayName: "Highest Video Resolution",
                backingValue: highestVideoResolution,
                formattedValue: highestVideoResolution?.formattedString ?? "Unknown"
            )

            let formattedMaximumFramerate: String
            if let maximumFramerate = maximumFramerate {
                formattedMaximumFramerate = "\(maximumFramerate)"
            } else {
                formattedMaximumFramerate = "Unknown"
            }

            self.maximumFramerate = GenericValue(
                displayName: "Maximum Framerate",
                backingValue: maximumFramerate,
                formattedValue: formattedMaximumFramerate
            )

            allValues = [
                uniqueID.asAny(),
                modelID.asAny(),
                self.highestStillImageResolution.asAny(),
                self.supportsHDRVideo.asAny(),
                self.highestVideoResolution.asAny(),
                self.maximumFramerate.asAny(),
            ]
        }

    }

    public static let availability: SourceAvailability = .available

    public let displayName = "Cameras"

    public let front: GenericValue<Camera?, None>
    public let back: GenericValue<Camera?, None>

    public var allValues: [AnyValue] {
        return [
            front.asAny(),
            back.asAny(),
        ]
    }

    public init() {
        let frontCaptureDevice: AVCaptureDevice?
        let backCaptureDevice: AVCaptureDevice?

        if #available(iOS 10.0, *) {
            let deviceTypes: [AVCaptureDevice.DeviceType]
            if #available(iOS 11.1, *) {
               deviceTypes  = [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInDualCamera, .builtInTrueDepthCamera]
            } else if #available(iOS 10.2, *) {
                deviceTypes  = [.builtInWideAngleCamera, .builtInTelephotoCamera, .builtInDualCamera]
            } else {
                deviceTypes  = [.builtInWideAngleCamera, .builtInTelephotoCamera]
            }

            func defaultDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
                for deviceType in deviceTypes {
                    if let device = AVCaptureDevice.default(deviceType, for: nil, position: position) {
                        return device
                    }
                }

                return nil
            }

            frontCaptureDevice = defaultDevice(position: .front)
            backCaptureDevice = defaultDevice(position: .back)
        } else {
            let devices = AVCaptureDevice.devices()
            frontCaptureDevice = devices.first { $0.position == .front }
            backCaptureDevice = devices.first { $0.position == .back }
        }

        if let frontCaptureDevice = frontCaptureDevice {
            let camera = Camera(captureDevice: frontCaptureDevice)
            front = GenericValue(displayName: frontCaptureDevice.localizedName, backingValue: camera)
        } else {
            front = GenericValue(displayName: "Front Camera")
        }

        if let backCaptureDevice = backCaptureDevice {
            let camera = Camera(captureDevice: backCaptureDevice)
            back = GenericValue(displayName: backCaptureDevice.localizedName, backingValue: camera)
        } else {
            back = GenericValue(displayName: "Back Camera")
        }
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
