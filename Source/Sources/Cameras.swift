import Foundation
import AVFoundation

public final class Cameras: BaseSource, Source, Controllable, ValuesProvider {

    private enum State {
        case notMonitoring
        case monitoring(notificationObservers: NotificationObservers, updatesQueue: OperationQueue)

        // swiftlint:disable:next nesting
        struct NotificationObservers {
            let deviceConnected: NSObjectProtocol
            let deviceDisconnected: NSObjectProtocol
        }
    }

    public static let availability: SourceAvailability = .available

    public static let name = "Cameras"

    public private(set) var cameras: [Camera]

    public var front: Camera? {
        guard let frontId = AVCaptureDevice.frontCaptureDevice()?.uniqueID else { return nil }
        return cameras.first(where: { $0.uniqueID == frontId })
    }

    public var back: Camera? {
        guard let backId = AVCaptureDevice.backCaptureDevice()?.uniqueID else { return nil }
        return cameras.first(where: { $0.uniqueID == backId })
    }

    private var state: State = .notMonitoring

    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public var allValues: [Value] {
        return cameras
    }

    public override init() {
        cameras = AVCaptureDevice.devices().map(Camera.init(captureDevice:))
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "uk.co.josephduffy.GatheredKit Cameras Updates"
        let deviceConnectedListener = NotificationCenter.default.addObserver(
            forName: .AVCaptureDeviceWasConnected,
            object: nil,
            queue: updatesQueue
        ) { [unowned self] notification in
            guard let device = notification.object as? AVCaptureDevice else { return }
            self.cameras.append(Camera(captureDevice: device))
            self.notifyListenersPropertyValuesUpdated()
        }

        let deviceDisconnectedListener = NotificationCenter.default.addObserver(
            forName: .AVCaptureDeviceWasDisconnected,
            object: nil,
            queue: updatesQueue
        ) { [unowned self] notification in
            guard let device = notification.object as? AVCaptureDevice else { return }
            self.cameras.removeAll(where: { $0.uniqueID == device.uniqueID })
        }

        state = .monitoring(
            notificationObservers: Cameras.State.NotificationObservers(
                deviceConnected: deviceConnectedListener,
                deviceDisconnected: deviceDisconnectedListener
            ),
            updatesQueue: updatesQueue
        )
    }

    public func stopUpdating() {
        guard case .monitoring(let observers, _) = state else { return }

        NotificationCenter.default.removeObserver(
            observers.deviceConnected,
            name: .AVCaptureDeviceWasConnected,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            observers.deviceDisconnected,
            name: .AVCaptureDeviceWasDisconnected,
            object: nil
        )

        state = .notMonitoring
    }

}

public extension Cameras {

    struct Camera: TypedValue, ValuesProvider {

        public let uniqueID: GenericUnitlessValue<String>
        public let modelID: GenericUnitlessValue<String>
        // TODO: Add unit
        public let highestStillImageResolution: GenericUnitlessValue<CMVideoDimensions?>
        public let supportsHDRVideo: GenericValue<Bool?, Boolean>
        // TODO: Add unit
        public let highestVideoResolution: GenericUnitlessValue<CMVideoDimensions?>
        public let maximumFramerate: GenericUnitlessValue<Float64?>

        public let allValues: [Value]

        public let backingValue: AVCaptureDevice

        public let displayName: String

        public let formattedValue: String? = nil

        public let date = Date()

        public init(captureDevice: AVCaptureDevice) {
            backingValue = captureDevice
            displayName = captureDevice.localizedName
            
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
