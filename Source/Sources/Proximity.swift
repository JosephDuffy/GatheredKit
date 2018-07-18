import UIKit

public final class Proximity: BaseSource, ControllableSource {

    /// A count of the total number of `Proximity` sources
    /// that are actively updating. This is used to not stop other `Proximity` sources
    /// when `stopUpdating` is called
    private static var totalUpdatingInstances: Int = 0

    private enum State {
        case notMonitoring
        case monitoring(notificationObserver: NSObjectProtocol, updatesQueue: OperationQueue)
    }

    public static var availability: SourceAvailability {
        let device = UIDevice.current

        guard !device.isProximityMonitoringEnabled else { return .available }

        device.isProximityMonitoringEnabled = true
        let isAvailable = device.isProximityMonitoringEnabled
        device.isProximityMonitoringEnabled = false

        return isAvailable ? .available : .unavailable
    }

    public static var displayName = "Proximity"

    /// A boolean indicating if the screen is monitoring for brightness changes
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public private(set) var isNearUser: GenericValue<Bool?, Boolean>

    public var allValues: [AnyValue] {
        return [
            isNearUser.asAny(),
        ]
    }

    private let device: UIDevice = .current

    private var state: State = .notMonitoring

    public override init() {
        isNearUser = GenericValue(
            displayName: "Near User",
            unit: Boolean(trueString: "Yes", falseString: "No")
        )
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating() {
        device.isProximityMonitoringEnabled = true

        guard device.isProximityMonitoringEnabled else { return }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "uk.co.josephduffy.GatheredKit Proximity Updates"

        let notificationObserver = NotificationCenter.default.addObserver(forName: UIDevice.proximityStateDidChangeNotification, object: device, queue: updatesQueue) { [weak self] _ in
            guard let `self` = self else { return }

            self.isNearUser.update(backingValue: self.device.proximityState)
            self.notifyListenersPropertyValuesUpdated()
        }

        Proximity.totalUpdatingInstances += 1

        state = .monitoring(notificationObserver: notificationObserver, updatesQueue: updatesQueue)

        isNearUser.update(backingValue: device.proximityState)
        notifyListenersPropertyValuesUpdated()
    }

    public func stopUpdating() {
        guard case .monitoring(let notificationObserver, _) = state else { return }

        Proximity.totalUpdatingInstances -= 1

        if Proximity.totalUpdatingInstances == 0 {
            device.isProximityMonitoringEnabled = false
        }

        NotificationCenter.default.removeObserver(notificationObserver)

        state = .notMonitoring
    }

}
