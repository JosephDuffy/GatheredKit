#if os(iOS) || os(macOS)
import Combine
import GatheredKit
import AVFoundation

/// A wrapper around `AVCaptureDevice`.
public final class Camera: UpdatingSource, Controllable {
    /// The default, general-purpose camera. This will always have the device
    /// type `AVCaptureDevice.DeviceType.builtInWideAngleCamera`.
    public static var `default`: Camera? {
        guard let defaultVideoCamera = AVCaptureDevice.default(for: .video) else { return nil }
        return Camera(captureDevice: defaultVideoCamera)
    }

    public let availability: SourceAvailability = .available

    public let name: String

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    /// A boolean indicating if the screen is monitoring for brightness changes
    public private(set) var isUpdating: Bool = false

    /// The `UIScreen` this `Screen` represents.
    public let captureDevice: AVCaptureDevice

    @StringProperty
    public private(set) var uniqueID: String

    @AVCaptureDevicePosition
    public private(set) var position: AVCaptureDevice.Position

    public var allProperties: [AnyProperty] {
        [
            $uniqueID,
            $position,
        ]
    }

    public init(captureDevice: AVCaptureDevice) {
        self.captureDevice = captureDevice
        _uniqueID = .init(displayName: "Unique Identifier", value: captureDevice.uniqueID)
        name = captureDevice.localizedName
        _position = .init(displayName: "Position", value: captureDevice.position)
    }

    /**
     Start automatically monitoring changes to the source. This will start delegate methods being called
     when new data is available
     */
    public func startUpdating() {

    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopUpdating() {

    }
}

#endif
