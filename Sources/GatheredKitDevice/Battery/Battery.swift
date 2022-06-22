#if canImport(UIKit)
import Combine
import GatheredKit
import UIKit

@available(tvOS, unavailable)
public final class Battery: UpdatingSource, Controllable {
    private enum State {
        case notMonitoring
        case monitoring(notificationCancellables: Set<AnyCancellable>)
    }

    public let availability: SourceAvailability = .available

    public let name: String

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    @Published
    public private(set) var isUpdating: Bool = false

    public var isUpdatingPublisher: AnyPublisher<Bool, Never> {
        $isUpdating.eraseToAnyPublisher()
    }

    /// The `UIDevice` to read the level and state from.
    public let device: UIDevice

    /// The `ProcessInfo` used to determine if low power mode is enabled.
    public let processInfo: ProcessInfo

    /// The current battery level, expressed as a percentage, ranging from 0.0
    /// to 1.0.
    ///
    /// This property will update automatically no more frequently than once per
    /// minute.
    @BasicProperty<Float, BatteryLevelFormatter>
    public private(set) var level: Float

    @BatteryStateProperty
    public private(set) var state: UIDevice.BatteryState

    @BoolProperty
    public private(set) var isLowPowerModeEnabled: Bool

    public var allProperties: [AnyProperty] {
        [
            $level,
            $state,
            $isLowPowerModeEnabled,
        ]
    }

    private var monitoringState: State = .notMonitoring {
        didSet {
            switch monitoringState {
            case .monitoring:
                isUpdating = true
            case .notMonitoring:
                isUpdating = false
            }
        }
    }

    private let notificationCenter: NotificationCenter

    private var propertiesCancellables: [AnyCancellable] = []

    public convenience init(device: UIDevice = .current, processInfo: ProcessInfo = .processInfo) {
        self.init(device: device, processInfo: processInfo, notificationCenter: .default)
    }

    internal init(device: UIDevice, processInfo: ProcessInfo, notificationCenter: NotificationCenter) {
        self.device = device
        self.processInfo = processInfo
        self.notificationCenter = notificationCenter
        name = "Battery"
        _level = .init(
            displayName: "Level",
            value: device.batteryLevel
        )
        _state = .init(
            displayName: "State",
            value: device.batteryState
        )
        _isLowPowerModeEnabled = .init(
            displayName: "Low Power Mode",
            value: processInfo.isLowPowerModeEnabled,
            formatter: BoolFormatter(trueString: "Enabled", falseString: "Disabled")
        )

        propertiesCancellables = allProperties.map { property in
            property
                .typeErasedSnapshotPublisher
                .sink { [weak property, eventsSubject] snapshot in
                    guard let property = property else { return }
                    eventsSubject.send(.propertyUpdated(property: property, snapshot: snapshot))
                }
        }
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        device.isBatteryMonitoringEnabled = true

        var notificationCancellables: Set<AnyCancellable> = []

        notificationCenter
            .publisher(for: UIDevice.batteryLevelDidChangeNotification, object: device)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self._level.updateValueIfDifferent(self.device.batteryLevel)
            }
            .store(in: &notificationCancellables)

        notificationCenter
            .publisher(for: UIDevice.batteryStateDidChangeNotification, object: device)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self._state.updateValueIfDifferent(self.device.batteryState)
            }
            .store(in: &notificationCancellables)

        notificationCenter
            .publisher(for: .NSProcessInfoPowerStateDidChange, object: processInfo)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self._isLowPowerModeEnabled.updateValueIfDifferent(self.processInfo.isLowPowerModeEnabled)
            }
            .store(in: &notificationCancellables)

        _level.updateValueIfDifferent(device.batteryLevel)
        _state.updateValueIfDifferent(device.batteryState)
        _isLowPowerModeEnabled.updateValueIfDifferent(processInfo.isLowPowerModeEnabled)

        monitoringState = .monitoring(notificationCancellables: notificationCancellables)
    }

    public func stopUpdating() {
        stopUpdating(stopBatteryMonitoring: true)
    }

    public func stopUpdating(stopBatteryMonitoring: Bool) {
        guard isUpdating else { return }
        monitoringState = .notMonitoring
        if stopBatteryMonitoring {
            device.isBatteryMonitoringEnabled = false
        }
    }
}
#endif
