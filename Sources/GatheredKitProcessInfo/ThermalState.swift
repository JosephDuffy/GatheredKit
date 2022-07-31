import Combine
import Foundation
import GatheredKit

public final class ThermalState: UpdatingSource, Controllable {
    public let availability: SourceAvailability = .available

    public let name: String

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    /// A boolean indicating if the screen is monitoring for brightness changes
    @Published
    public private(set) var isUpdating: Bool = false

    public var isUpdatingPublisher: AnyPublisher<Bool, Never> {
        $isUpdating.eraseToAnyPublisher()
    }

    /// The `ProcessInfo` this `ThermalState` reads from.
    public let processInfo: ProcessInfo

    @ProcessInfoThermalStateProperty
    public private(set) var state: ProcessInfo.ThermalState

    public var allProperties: [AnyProperty] {
        [
            $state,
        ]
    }

    private let notificationCenter: NotificationCenter

    private var cancellables: Set<AnyCancellable> = []

    public init(processInfo: ProcessInfo = .processInfo, notificationCenter: NotificationCenter = .default) {
        self.processInfo = processInfo
        self.notificationCenter = notificationCenter
        _state = .init(
            displayName: NSLocalizedString(
                "source.thermal-state.property.state",
                bundle: .module,
                comment: ""
            ),
            value: processInfo.thermalState
        )
        name = NSLocalizedString(
            "source.thermal-state.name",
            bundle: .module,
            comment: ""
        )
    }

    /**
     Start automatically monitoring changes to the source. This will start delegate methods being called
     when new data is available
     */
    public func startUpdating() {
        isUpdating = true
        eventsSubject.send(.startedUpdating)
        notificationCenter
            .publisher(for: ProcessInfo.thermalStateDidChangeNotification, object: processInfo)
            .compactMap { $0.object as? ProcessInfo }
            .receive(on: RunLoop.main)
            .sink { [weak self] processInfo in
                guard let self = self else { return }
                self._state.updateValue(processInfo.thermalState)
            }
            .store(in: &cancellables)

        _state.updateValueIfDifferent(processInfo.thermalState)
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopUpdating() {
        isUpdating = false
        cancellables = []
        eventsSubject.send(.stoppedUpdating())
    }
}
