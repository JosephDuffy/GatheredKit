import UIKit

public final class DeviceOrientation: BaseSource, Source, Controllable {

    /// A dictionary mapping `UIDevice`s to the total number of `DeviceOrientation` sources
    /// that are actively updating. This is used to not stop other `DeviceOrientation` sources
    /// when `stopUpdating` is called
    private static var totalMonitoringSources: [UIDevice: Int] = [:]

    public enum ScreenDirection {
        case up
        case down
    }

    public enum ScreenOrientation {
        case portrait
        case landscapeRight
        case portraitUpsideDown
        case landscapeLeft
    }

    private enum State {
        case notMonitoring
        case monitoring(notificationObserver: NSObjectProtocol, updatesQueue: OperationQueue)
    }

    public static let availability: SourceAvailability = .available

    public let displayName = "Device Orientation"

    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public private(set) var screenOrientation: GenericValue<ScreenOrientation?, None>
    public private(set) var screenDirection: GenericValue<ScreenDirection?, None>

    public var allValues: [AnyValue] {
        return [
            screenOrientation.asAny(),
            screenDirection.asAny(),
        ]
    }

    private let device: UIDevice

    private var state: State = .notMonitoring

    public convenience override init() {
        self.init(device: .current)
    }

    public init(device: UIDevice) {
        self.device = device

        screenOrientation = GenericValue(displayName: "Screen Orientation")
        screenDirection = GenericValue(displayName: "Screen Direction")
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "uk.co.josephduffy.GatheredKit Device Orientations Updates"

        let notificationObserver = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: device, queue: updatesQueue) { [weak self] _ in
            guard let `self` = self else { return }

            self.updateValues()
            self.notifyListenersPropertyValuesUpdated()
        }

        state = .monitoring(notificationObserver: notificationObserver, updatesQueue: updatesQueue)

        DeviceOrientation.totalMonitoringSources[device] = (DeviceOrientation.totalMonitoringSources[device] ?? 0) + 1

        device.beginGeneratingDeviceOrientationNotifications()

        updateValues()
        notifyListenersPropertyValuesUpdated()
    }

    public func stopUpdating() {
        guard case .monitoring(let notificationObserver, _) = state else { return }

        NotificationCenter.default.removeObserver(notificationObserver, name: UIDevice.orientationDidChangeNotification, object: device)

        if let totalMonitoringSources = DeviceOrientation.totalMonitoringSources[device] {
            if totalMonitoringSources == 1 {
                device.endGeneratingDeviceOrientationNotifications()
                DeviceOrientation.totalMonitoringSources.removeValue(forKey: device)
            } else {
                DeviceOrientation.totalMonitoringSources[device] = totalMonitoringSources - 1
            }
        }

        state = .notMonitoring
    }

    private func updateValues() {
        switch device.orientation {
        case .faceUp:
            screenDirection.update(backingValue: .up, formattedValue: "Up")
        case .faceDown:
            screenDirection.update(backingValue: .down, formattedValue: "Down")
        case .portrait:
            screenOrientation.update(backingValue: .portrait, formattedValue: "Portrait")
        case .landscapeRight:
            screenOrientation.update(backingValue: .landscapeRight, formattedValue: "Landscape Right")
        case .portraitUpsideDown:
            screenOrientation.update(backingValue: .portraitUpsideDown, formattedValue: "Portrait Upside Down")
        case .landscapeLeft:
            screenOrientation.update(backingValue: .landscapeLeft, formattedValue: "Landscape Left")
        case .unknown:
            screenOrientation.update(backingValue: nil, formattedValue: "Unknown")
            screenDirection.update(backingValue: nil, formattedValue: "Unknown")
        }
    }
}
