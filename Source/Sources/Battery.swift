import UIKit

public final class Battery: BaseSource, Source, Controllable, ManuallyUpdatableValuesProvider {

    /// A dictionary mapping `UIDevice`s to the total number of `Battery` sources
    /// that are actively updating. This is used to not stop other `Battery` sources
    /// when `stopUpdating` is called
    private static var totalMonitoringSources: [UIDevice: Int] = [:]

    private enum State {
        case notMonitoring
        case monitoring(notificationObservers: NotificationObservers, updatesQueue: OperationQueue)

        // swiftlint:disable:next nesting
        struct NotificationObservers {
            let batteryLevel: NSObjectProtocol
            let batteryState: NSObjectProtocol
            let lowPowerModeState: NSObjectProtocol
        }

    }

    public static var availability: SourceAvailability = .available

    public static var name = "Battery"

    /// A boolean indicating if the screen is monitoring for brightness changes
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public private(set) var chargeLevel: GenericValue<Float, Percent>
    public private(set) var chargeState: GenericUnitlessValue<UIDevice.BatteryState>
    public private(set) var isLowPowerModeEnabled: GenericValue<Bool, Boolean>

    public var allValues: [Value] {
        return [
            chargeLevel,
            chargeState,
            isLowPowerModeEnabled,
        ]
    }

    private let device: UIDevice = .current

    private var state: State = .notMonitoring

    public override init() {
        chargeLevel = GenericValue(
            displayName: "Charge Level",
            backingValue: device.batteryLevel
        )
        chargeState = GenericUnitlessValue(
            displayName: "Battery State",
            backingValue: device.batteryState,
            formattedValue: device.batteryState.displayValue
        )
        isLowPowerModeEnabled = GenericValue(
            displayName: "Low Power Mode Enabled",
            backingValue: ProcessInfo.processInfo.isLowPowerModeEnabled,
            unit: Boolean(trueString: "Yes", falseString: "No")
        )
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating() {
        defer {
            updateValues()
        }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "uk.co.josephduffy.GatheredKit Battery Updates"

        let batteryLevelObserver = NotificationCenter.default.addObserver(forName: UIDevice.batteryLevelDidChangeNotification, object: device, queue: updatesQueue) { [weak self] _ in
            guard let `self` = self else { return }

            self.chargeLevel.update(backingValue: self.device.batteryLevel)
            self.notifyListenersPropertyValuesUpdated()
        }

        let batteryStateObserver = NotificationCenter.default.addObserver(forName: UIDevice.batteryStateDidChangeNotification, object: device, queue: updatesQueue) { [weak self] _ in
            guard let `self` = self else { return }

            let device = self.device
            self.chargeState.update(backingValue: device.batteryState, formattedValue: device.batteryState.displayValue)
            self.notifyListenersPropertyValuesUpdated()
        }

        let lowPowerModeStateObserver = NotificationCenter.default.addObserver(forName: .NSProcessInfoPowerStateDidChange, object: nil, queue: updatesQueue) { [weak self] _ in
            guard let `self` = self else { return }

            self.isLowPowerModeEnabled.update(backingValue: ProcessInfo.processInfo.isLowPowerModeEnabled)
            self.notifyListenersPropertyValuesUpdated()
        }

        Battery.totalMonitoringSources[device] = (Battery.totalMonitoringSources[device] ?? 0) + 1

        device.isBatteryMonitoringEnabled = true

        let notificationObservers = State.NotificationObservers(batteryLevel: batteryLevelObserver, batteryState: batteryStateObserver, lowPowerModeState: lowPowerModeStateObserver)
        state = .monitoring(notificationObservers: notificationObservers, updatesQueue: updatesQueue)
    }

    public func stopUpdating() {
        guard case .monitoring(let notificationObservers, _) = state else { return }

        NotificationCenter.default.removeObserver(notificationObservers.batteryLevel, name: UIDevice.batteryLevelDidChangeNotification, object: device)
        NotificationCenter.default.removeObserver(notificationObservers.batteryState, name: UIDevice.batteryStateDidChangeNotification, object: device)
        NotificationCenter.default.removeObserver(notificationObservers.lowPowerModeState, name: .NSProcessInfoPowerStateDidChange, object: nil)

        if let totalMonitoringSources = Battery.totalMonitoringSources[device] {
            if totalMonitoringSources == 1 {
                device.isBatteryMonitoringEnabled = false
                Battery.totalMonitoringSources.removeValue(forKey: device)
            } else {
                Battery.totalMonitoringSources[device] = totalMonitoringSources - 1
            }
        }

        state = .notMonitoring
    }

    @discardableResult
    public func updateValues() -> [Value] {
        defer {
            notifyListenersPropertyValuesUpdated()
        }

        chargeLevel.update(backingValue: device.batteryLevel)
        chargeState.update(backingValue: device.batteryState, formattedValue: device.batteryState.displayValue)
        isLowPowerModeEnabled.update(backingValue: ProcessInfo.processInfo.isLowPowerModeEnabled)

        return allValues
    }

}

#if swift(>=4.2)
private extension UIDevice.BatteryState {

    var displayValue: String {
        switch self {
        case .charging:
            return "Charging"
        case .full:
            return "Full"
        case .unplugged:
            return "Discharging"
        case .unknown:
            return "Unknown"
        }
    }

}
#else
private extension UIDeviceBatteryState {

    var displayValue: String {
        switch self {
        case .charging:
            return "Charging"
        case .full:
            return "Full"
        case .unplugged:
            return "Discharging"
        case .unknown:
            return "Unknown"
        }
    }

}
#endif
