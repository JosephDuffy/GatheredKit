#if canImport(UIKit)
import Combine
import GatheredKit
import UIKit

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

    /// The `AVCaptureDevice` this `Camera` represents.
    public let device: UIDevice

    /// The current battery level, expressed as a percentage, ranging from 0.0
    /// to 1.0.
    ///
    /// This property will update automatically no more frequently than once per
    /// minute.
    @BasicProperty<Float, BatteryLevelFormatter>
    public private(set) var level: Float

    @BatteryStateProperty
    public private(set) var state: UIDevice.BatteryState

    public var allProperties: [AnyProperty] {
        [
            $level,
            $state,
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

    public convenience init(device: UIDevice = .current) {
        self.init(device: device, notificationCenter: .default)
    }

    internal init(device: UIDevice, notificationCenter: NotificationCenter) {
        self.device = device
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

        _level.updateValueIfDifferent(device.batteryLevel)
        _state.updateValueIfDifferent(device.batteryState)

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
