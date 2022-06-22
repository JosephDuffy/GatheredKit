#if canImport(ExternalAccessory)
import Combine
import ExternalAccessory
import GatheredKit

public final class ExternalAccessoryProvider: UpdatingSourceProvider, ControllableSourceProvider {
    private enum State {
        case notMonitoring
        case monitoring(cancellables: Set<AnyCancellable>)
    }

    public let name = "External Accessories"

    public var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<ExternalAccessory>, Never> {
        sourceProviderEventsSubject.eraseToAnyPublisher()
    }

    private let sourceProviderEventsSubject = PassthroughSubject<SourceProviderEvent<ExternalAccessory>, Never>()

    @Published
    public private(set) var sources: [ExternalAccessory]

    @Published
    public private(set) var isUpdating: Bool = false

    public var isUpdatingPublisher: AnyPublisher<Bool, Never> {
        $isUpdating.eraseToAnyPublisher()
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

    private let accessoryManager: EAAccessoryManager

    private let notificationCenter: NotificationCenter

    public convenience init() {
        self.init(accessoryManager: .shared(), notificationCenter: .default)
    }

    internal required init(accessoryManager: EAAccessoryManager, notificationCenter: NotificationCenter) {
        self.accessoryManager = accessoryManager
        self.notificationCenter = notificationCenter
        sources = accessoryManager.connectedAccessories.map { accessory in
            ExternalAccessory(accessory: accessory)
        }
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        var cancellables: Set<AnyCancellable> = []

        notificationCenter
            .publisher(for: .EAAccessoryDidConnect, object: accessoryManager)
            .sink { [weak self] _ in
                guard let self = self else { return }

                self.updateSources()
            }
            .store(in: &cancellables)

        notificationCenter
            .publisher(for: .EAAccessoryDidDisconnect, object: accessoryManager)
            .sink { [weak self] _ in
                guard let self = self else { return }

                self.updateSources()
            }
            .store(in: &cancellables)

        accessoryManager.registerForLocalNotifications()
        updateSources()

        state = .monitoring(cancellables: cancellables)
        sourceProviderEventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        guard isUpdating else { return }

        state = .notMonitoring
        accessoryManager.unregisterForLocalNotifications()
        sourceProviderEventsSubject.send(.stoppedUpdating())
    }

    private func updateSources() {
        #warning("TODO: Perform a diff based on ids")
        sources = accessoryManager.connectedAccessories.map { accessory in
            ExternalAccessory(accessory: accessory)
        }
//        sourceProviderEventsSubject.send(.sourceAdded(<#T##ExternalAccessory#>))
    }
}
#endif
