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

    public static let name = "Device Orientation"

    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public private(set) var screenOrientation: GenericUnitlessProperty<ScreenOrientation?>
    public private(set) var screenDirection: GenericUnitlessProperty<ScreenDirection?>

    public var allProperties: [AnyProperty] {
        return [
            screenOrientation,
            screenDirection,
        ]
    }

    private let device: UIDevice = .current

    private var state: State = .notMonitoring

    public override init() {
        screenOrientation = GenericUnitlessValue(displayName: "Screen Orientation")
        screenDirection = GenericUnitlessValue(displayName: "Screen Direction")
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
            screenDirection.update(value: .up, formattedValue: "Up")
        case .faceDown:
            screenDirection.update(value: .down, formattedValue: "Down")
        case .portrait:
            screenOrientation.update(value: .portrait, formattedValue: "Portrait")
        case .landscapeRight:
            screenOrientation.update(value: .landscapeRight, formattedValue: "Landscape Right")
        case .portraitUpsideDown:
            screenOrientation.update(value: .portraitUpsideDown, formattedValue: "Portrait Upside Down")
        case .landscapeLeft:
            screenOrientation.update(value: .landscapeLeft, formattedValue: "Landscape Left")
        case .unknown:
            screenOrientation.update(value: nil, formattedValue: "Unknown")
            screenDirection.update(value: nil, formattedValue: "Unknown")
        }
    }
}
