import Foundation
import AVFoundation

public final class Cameras: BaseSource, Source, Controllable, PropertiesProvider {

    public typealias Camera = Property<AVCaptureDevice, UnitNone>

    private enum State {
        case notMonitoring
        case monitoring(notificationObservers: NotificationObservers, updatesQueue: OperationQueue)

        fileprivate struct NotificationObservers {
            let deviceConnected: NSObjectProtocol
            let deviceDisconnected: NSObjectProtocol
        }
    }

    public static let availability: SourceAvailability = .available

    public static let name = "Cameras"

    public private(set) var cameras: [Camera]

    private var state: State = .notMonitoring

    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public var allProperties: [AnyProperty] {
        return cameras
    }

    public override init() {
        let allDevices = AVCaptureDevice.devices(position: .front)
            + AVCaptureDevice.devices(position: .back)
            + AVCaptureDevice.devices(position: .unspecified)
        cameras = allDevices.map(Camera.init(captureDevice:))
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

public extension Value where ValueType == AVCaptureDevice {
    public var uniqueID: Property<String> {
        return Value(
            displayName: "Unique ID",
            value: value.uniqueID
        )
    }
}

////public extension Cameras {
////
////    struct Camera: Value, PropertiesProvider {
////
////        public let uniqueID: GenericUnitlessProperty<String>
////        public let modelID: GenericUnitlessProperty<String>
////        public let position: GenericUnitlessProperty<AVCaptureDevice.Position>
////        // TODO: Add unit
////        public let highestStillImageResolution: GenericUnitlessProperty<CMVideoDimensions?>
////        public let supportsHDRVideo: GenericProperty<Bool?, Boolean>
////        // TODO: Add unit
////        public let highestVideoResolution: GenericUnitlessProperty<CMVideoDimensions?>
////        public let maximumFramerate: GenericUnitlessProperty<Float64?>
////
////        public let allProperties: [AnyProperty]
////
////        public let value: AVCaptureDevice
////
////        public let displayName: String
////
////        public let formattedValue: String? = nil
////
////        public let date = Date()
////
////        public init(captureDevice: AVCaptureDevice) {
////            value = captureDevice
////            displayName = captureDevice.localizedName
////
////            uniqueID = GenericUnitlessValue(
////                displayName: "Unique ID",
////                value: captureDevice.uniqueID
////            )
////            modelID = GenericUnitlessValue(
////                displayName: "Model ID",
////                value: captureDevice.modelID
////            )
////            position = GenericUnitlessValue(
////                displayName: "Position",
////                value: captureDevice.position,
////                formattedValue: captureDevice.position.displayValue
////            )
////
////            let metadata = FormatsMetadata(formats: captureDevice.formats)
////
////            highestStillImageResolution = GenericUnitlessValue(
////                displayName: "Highest Still Image Resolution",
////                value: metadata.highestStillImageResolution,
////                formattedValue: metadata.highestStillImageResolution?.formattedString ?? "Unknown"
////            )
////
////            supportsHDRVideo = GenericValue(
////                displayName: "Supports HDR Video",
////                value: metadata.supportsHDRVideo,
////                formattedValue: metadata.supportsHDRVideo == nil ? "Unknown" : nil,
////                unit: Boolean(trueString: "Yes", falseString: "No")
////            )
////
////            highestVideoResolution = GenericUnitlessValue(
////                displayName: "Highest Video Resolution",
////                value: metadata.highestVideoResolution,
////                formattedValue: metadata.highestVideoResolution?.formattedString ?? "Unknown"
////            )
////
////            let formattedMaximumFramerate: String
////            if let maximumFramerate = metadata.maximumFramerate {
////                formattedMaximumFramerate = "\(maximumFramerate)"
////            } else {
////                formattedMaximumFramerate = "Unknown"
////            }
////
////            maximumFramerate = GenericUnitlessValue(
////                displayName: "Maximum Framerate",
////                value: metadata.maximumFramerate,
////                formattedValue: formattedMaximumFramerate
////            )
////
////            allProperties = [
////                uniqueID,
////                modelID,
////                highestStillImageResolution,
////                supportsHDRVideo,
////                highestVideoResolution,
////                maximumFramerate
////            ]
////        }
////    }
////
////}
//
//private extension Cameras.Camera {
//
//    struct FormatsMetadata {
//        let highestStillImageResolution: CMVideoDimensions?
//        let supportsHDRVideo: Bool?
//        let highestVideoResolution: CMVideoDimensions?
//        let maximumFramerate: Float64?
//
//        init(formats: [AVCaptureDevice.Format]) {
//            var highestStillImageResolution: CMVideoDimensions?
//            var supportsHDRVideo: Bool?
//            var highestVideoResolution: CMVideoDimensions?
//            var maximumFramerate: Float64?
//
//            for format in formats {
//                if
//                    highestStillImageResolution == nil ||
//                    format.highResolutionStillImageDimensions.totalPixels >
//                        highestStillImageResolution?.totalPixels ?? 0
//                {
//                    highestStillImageResolution = format.highResolutionStillImageDimensions
//                }
//
//                let videoResolution = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
//
//                if
//                    highestVideoResolution == nil ||
//                    videoResolution.totalPixels >
//                        highestVideoResolution?.totalPixels ?? 0
//                {
//                    highestVideoResolution = videoResolution
//                }
//
//                for frameRateRange in format.videoSupportedFrameRateRanges {
//                    if
//                        maximumFramerate == nil ||
//                        frameRateRange.maxFrameRate > maximumFramerate ?? 0
//                    {
//                        maximumFramerate = frameRateRange.maxFrameRate
//                    }
//                }
//
//                if #available(iOS 10, *) {
//                    if format.supportedColorSpaces.contains(.P3_D65) {
//                        supportsHDRVideo = true
//                    } else if supportsHDRVideo == nil {
//                        supportsHDRVideo = false
//                    }
//                }
//            }
//
//            self.highestStillImageResolution = highestStillImageResolution
//            self.supportsHDRVideo = supportsHDRVideo
//            self.highestVideoResolution = highestVideoResolution
//            self.maximumFramerate = maximumFramerate
//        }
//    }
//
//}

private extension AVCaptureDevice {

    static func devices(position: AVCaptureDevice.Position) -> [AVCaptureDevice] {
        if #available(iOS 10.0, *) {
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

            let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: position)
            // When using `unspecified` for the position this will include devices with `front` and `back` positions, too
            return discoverySession.devices.filter { $0.position == position }
        } else {
            let devices = AVCaptureDevice.devices()
            return devices.filter { $0.position == position }
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

private extension AVCaptureDevice.Position {

    var displayValue: String {
        switch self {
        case .front:
            return "Front"
        case .back:
            return "Back"
        case .unspecified:
            return "Unspecified"
        }
    }

}
