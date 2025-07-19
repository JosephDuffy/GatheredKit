#if canImport(ExternalAccessory)
import Combine
import ExternalAccessory
import GatheredKit

public final class ExternalAccessoryProvider: UpdatingSourceProvider, ControllableSourceProvider {
    private enum State {
        case notMonitoring
        case monitoring(cancellables: Set<AnyCancellable>)
    }

    public var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<ExternalAccessory>, Never> {
        sourceProviderEventsSubject.eraseToAnyPublisher()
    }

    private let sourceProviderEventsSubject = PassthroughSubject<SourceProviderEvent<ExternalAccessory>, Never>()

    public let id: SourceProviderIdentifier

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
        id = SourceProviderIdentifier(sourceKind: .externalAccessory)
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
        let previousIds = Set(sources.map { $0.connectionID })
        let newIds = Set(accessoryManager.connectedAccessories.map(\.connectionID))

        let removedIds = previousIds.subtracting(newIds)
        let removedSources = sources.filter { source in
            removedIds.contains(source.connectionID)
        }

        /// The array of sources that this source provider will provide after the update.
        var newSources: [ExternalAccessory] = []
        /// The array of sources that were added during the update.
        var addedSources: [ExternalAccessory] = []

        for connectedAccessory in accessoryManager.connectedAccessories {
            if let existingSource = sources.first(where: { $0.connectionID == connectedAccessory.connectionID }) {
                newSources.append(existingSource)
            } else {
                let source = ExternalAccessory(accessory: connectedAccessory)
                newSources.append(source)
                addedSources.append(source)
            }
        }

        sources = newSources

        for source in removedSources {
            sourceProviderEventsSubject.send(.sourceRemoved(source))
        }

        for source in addedSources {
            sourceProviderEventsSubject.send(.sourceAdded(source))
        }
    }
}
#endif
