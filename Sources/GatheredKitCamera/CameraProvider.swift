import AVFoundation
import Combine
import GatheredKit

public final class CameraProvider: SourceProvider {
    public let name = "Cameras"

    @Published
    public private(set) var sources: [Camera]

    public init(
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
