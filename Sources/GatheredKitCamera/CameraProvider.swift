import AVFoundation
import Combine
import GatheredKit

@available(macOS 10.7, iOS 4, macCatalyst 14, *)
public final class CameraProvider: SourceProvider {
    public let name = "Cameras"

    @Published
    public private(set) var sources: [Camera]

    #if os(iOS)
    public convenience init(
        deviceTypes: [AVCaptureDevice.DeviceType] = [
            .builtInDualWideCamera,
            .builtInDualCamera,
//            .builtInLiDARDepthCamera,
            .builtInTelephotoCamera,
            .builtInTripleCamera,
            .builtInUltraWideCamera,
            .builtInWideAngleCamera,
        ],
        positions: [AVCaptureDevice.Position] = [
            .unspecified, .back, .front
        ]
    ) {
        self.init(_deviceTypes: deviceTypes, _positions: positions)
    }
    #elseif os(macOS)
    public convenience init(
        deviceTypes: [AVCaptureDevice.DeviceType] = [
            .builtInWideAngleCamera,
        ],
        positions: [AVCaptureDevice.Position] = [
            .unspecified, .back, .front
        ]
    ) {
        self.init(_deviceTypes: deviceTypes, _positions: positions)
    }
    #endif

    private init(_deviceTypes deviceTypes: [AVCaptureDevice.DeviceType], _positions positions: [AVCaptureDevice.Position]) {
        let captureDevices: [AVCaptureDevice] = positions.flatMap { position -> [AVCaptureDevice] in
            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: deviceTypes,
                mediaType: .video,
                position: position
            )
            return discoverySession.devices
        }
        var sources: [Camera] = []
        for captureDevice in captureDevices where !sources.contains(where: { $0.uniqueID == captureDevice.uniqueID }) {
            sources.append(Camera(captureDevice: captureDevice))
        }
        self.sources = sources
    }
}
