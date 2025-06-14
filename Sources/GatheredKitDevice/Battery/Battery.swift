#if os(iOS) || os(tvOS)
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

    /// The `UIDevice` to read the level and state from.
    public let device: UIDevice

    /// The `ProcessInfo` used to determine if low power mode is enabled.
    public let processInfo: ProcessInfo

    /// The current battery level, expressed as a percentage, ranging from 0.0
    /// to 1.0.
    ///
    /// This property will update automatically no more frequently than once per
    /// minute.
    @BasicProperty
    public private(set) var level: Float

    @BasicProperty
    public private(set) var state: UIDevice.BatteryState

    @BasicProperty
    public private(set) var isLowPowerModeEnabled: Bool

    public var allProperties: [any Property] {
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

    @MainActor
    public convenience init(device: UIDevice) {
        self.init(device: device, processInfo: .processInfo, notificationCenter: .default)
    }

    @MainActor
    public convenience init(processInfo: ProcessInfo) {
        self.init(device: .current, processInfo: processInfo, notificationCenter: .default)
    }

    @MainActor
    internal init(device: UIDevice, processInfo: ProcessInfo, notificationCenter: NotificationCenter) {
        id = SourceIdentifier(sourceKind: .battery)
        self.device = device
        self.processInfo = processInfo
        self.notificationCenter = notificationCenter
        _level = .init(
            id: id.identifierForChildPropertyWithId("level"),
            value: device.batteryLevel
        )
        _state = .init(
            id: id.identifierForChildPropertyWithId("state"),
            value: device.batteryState
        )
        _isLowPowerModeEnabled = .init(
            id: id.identifierForChildPropertyWithId("isLowPowerModeEnabled"),
            value: processInfo.isLowPowerModeEnabled
        )
    }

    @MainActor
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

    @MainActor
    public func stopUpdating() {
        stopUpdating(stopBatteryMonitoring: true)
    }

    @MainActor
    public func stopUpdating(stopBatteryMonitoring: Bool) {
        guard isUpdating else { return }
        monitoringState = .notMonitoring
        if stopBatteryMonitoring {
            device.isBatteryMonitoringEnabled = false
        }
    }
}
#endif
