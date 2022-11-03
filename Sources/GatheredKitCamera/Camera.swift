import AVFoundation
import Combine
import GatheredKit

/// A wrapper around `AVCaptureDevice`.
@available(macOS 10.7, iOS 4, macCatalyst 14, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public final class Camera: UpdatingSource, Controllable, Identifiable {
    private enum State {
        case notMonitoring
        case monitoring(observations: [NSKeyValueObservation])
    }

    /// The default, general-purpose camera. This will always have the device
    /// type `AVCaptureDevice.DeviceType.builtInWideAngleCamera`.
    public static var `default`: Camera? {
        guard let defaultVideoCamera = AVCaptureDevice.default(for: .video) else { return nil }
        return Camera(captureDevice: defaultVideoCamera)
    }

    public let availability: SourceAvailability = .available

    public let id: SourceIdentifier

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    @Published
    public private(set) var isUpdating: Bool = false

    public var isUpdatingPublisher: AnyPublisher<Bool, Never> {
        $isUpdating.eraseToAnyPublisher()
    }

    /// The `AVCaptureDevice` this `Camera` represents.
    public let captureDevice: AVCaptureDevice

    @StringProperty
    public private(set) var uniqueID: String

    @AVCaptureDevicePositionProperty
    public private(set) var position: AVCaptureDevice.Position

    @BoolProperty
    public private(set) var isConnected: Bool

    public var allProperties: [any Property] {
        [
            $uniqueID,
            $position,
            $isConnected,
        ]
    }

    private var state: State = .notMonitoring {
        didSet {
            switch state {
            case .monitoring:
                isUpdating = true
            case .notMonitoring:
                isUpdating = false
            }
        }
    }

    public init(captureDevice: AVCaptureDevice) {
        id = SourceIdentifier(
            sourceKind: .camera,
            instanceIdentifier: captureDevice.uniqueID,
            isTransient: false
        )
        self.captureDevice = captureDevice
        _uniqueID = .init(
            id: id.identifierForChildPropertyWithId("uniqueID"),
            value: captureDevice.uniqueID
        )
        _position = .init(
            id: id.identifierForChildPropertyWithId("position"),
            value: captureDevice.position
        )
        _isConnected = .init(
            id: id.identifierForChildPropertyWithId("isConnected"),
            value: captureDevice.isConnected
        )
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        _isConnected.updateValueIfDifferent(captureDevice.isConnected)

        let isConnectedObservation = captureDevice.observe(\.isConnected, options: .new) { [weak self] captureDevice, _ in
            self?._isConnected.updateValueIfDifferent(captureDevice.isConnected)
        }

        state = .monitoring(observations: [isConnectedObservation])
    }

    public func stopUpdating() {
        guard isUpdating else { return }
        state = .notMonitoring
    }
}
