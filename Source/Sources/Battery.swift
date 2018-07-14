import UIKit

public final class Battery: BaseSource, ControllableSource, ManuallyUpdatableSource {

    /// A dictionary mapping `UIDevice`s to the total number of `Battery` sources
    /// that are actively updating. This is used to not stop other `Battery` sources
    /// when `stopUpdating` is called
    private static var totalMonitoringSources: [UIDevice: Int] = [:]

    private enum State {
        case notMonitoring
        case monitoring(notificationObservers: [NSObjectProtocol], updatesQueue: OperationQueue)
    }

    public static var availability: SourceAvailability = .available

    public static var displayName = "Battery"

    /// A boolean indicating if the screen is monitoring for brightness changes
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public var chargeLevel: GenericValue<Float?, Percent>
    public var chargeState: GenericValue<UIDevice.BatteryState?, None>
    public var isLowPowerModeEnabled: GenericValue<Bool?, Boolean>

    public var allValues: [AnyValue] {
        return [
            chargeLevel.asAny(),
            chargeState.asAny(),
            isLowPowerModeEnabled.asAny(),
        ]
    }

    private let device: UIDevice

    private var state: State = .notMonitoring

    public convenience override init() {
        self.init(device: .current)
    }

    public init(device: UIDevice) {
        self.device = device
        
        chargeLevel = GenericValue(
            name: "Charge Level",
            backingValue: nil,
            unit: Percent()
        )
        chargeState = GenericValue(
            name: "Battery State",
            backingValue: nil,
            unit: None()
        )
        isLowPowerModeEnabled = GenericValue(
            name: "Low Power Mode Enabled",
            backingValue: nil,
            unit: Boolean(trueString: "Yes", falseString: "No")
        )
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating() {
        defer {
            updateProperties()
        }

        var notificationObservers = [NSObjectProtocol]()

        let updatesQueue = OperationQueue()
        updatesQueue.name = "uk.co.josephduffy.GatheredKit Battery Updates"

        notificationObservers.append(NotificationCenter.default.addObserver(forName: UIDevice.batteryLevelDidChangeNotification, object: device, queue: updatesQueue) { [weak self] _ in
            guard let `self` = self else { return }

            self.chargeLevel.update(backingValue: self.device.batteryLevel)
            self.notifyListenersPropertyValuesUpdated()
        })

        notificationObservers.append(NotificationCenter.default.addObserver(forName: UIDevice.batteryStateDidChangeNotification, object: device, queue: updatesQueue) { [weak self] _ in
            guard let `self` = self else { return }

            self.updateChargeState()
            self.notifyListenersPropertyValuesUpdated()
        })

        notificationObservers.append(NotificationCenter.default.addObserver(forName: .NSProcessInfoPowerStateDidChange, object: nil, queue: updatesQueue) { [weak self] _ in
            guard let `self` = self else { return }

            self.isLowPowerModeEnabled.update(backingValue: ProcessInfo.processInfo.isLowPowerModeEnabled)
            self.notifyListenersPropertyValuesUpdated()
        })

        Battery.totalMonitoringSources[device] = (Battery.totalMonitoringSources[device] ?? 0) + 1

        device.isBatteryMonitoringEnabled = true

        state = .monitoring(notificationObservers: notificationObservers, updatesQueue: updatesQueue)
    }

    public func stopUpdating() {
        guard case .monitoring(let notificationObservers, _) = state else { return }

        if let totalMonitoringSources = Battery.totalMonitoringSources[device] {
            if totalMonitoringSources == 1 {
                device.isBatteryMonitoringEnabled = false
                Battery.totalMonitoringSources.removeValue(forKey: device)
            } else {
                Battery.totalMonitoringSources[device] = totalMonitoringSources - 1
            }
        }

        notificationObservers.forEach(NotificationCenter.default.removeObserver(_:))

        state = .notMonitoring
    }

    @discardableResult
    public func updateProperties() -> [AnyValue] {
        defer {
            notifyListenersPropertyValuesUpdated()
        }

        chargeLevel.update(backingValue: device.batteryLevel)
        updateChargeState()
        isLowPowerModeEnabled.update(backingValue: ProcessInfo.processInfo.isLowPowerModeEnabled)

        return allValues
    }

    private func updateChargeState() {
        let displayValue: String

        switch device.batteryState {
        case .charging:
            displayValue = "Charging"
        case .full:
            displayValue = "Full"
        case .unplugged:
            displayValue = "Discharging"
        case .unknown:
            displayValue = "Unknown"
        }

        chargeState.update(backingValue: device.batteryState, formattedValue: displayValue)
    }

}
