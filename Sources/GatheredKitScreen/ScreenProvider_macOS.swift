#if os(macOS)
import AppKit
import Combine
import GatheredKit

public final class ScreenProvider: UpdatingSourceProvider, ControllableSourceProvider {
    private enum State {
        case notMonitoring
        case monitoring
    }

    public let id: SourceProviderIdentifier

    public var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<Screen>, Never> {
        sourceProviderEventsSubject.eraseToAnyPublisher()
    }

    private let sourceProviderEventsSubject = PassthroughSubject<SourceProviderEvent<Screen>, Never>()

    @Published
    public private(set) var sources: [Screen]

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

    private let notificationCenter: NotificationCenter

    public convenience init() {
        self.init(notificationCenter: .default)
    }

    internal required init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
        id = SourceProviderIdentifier(sourceKind: .screen)
        sources = NSScreen.screens.map { nsScreen in
            Screen(screen: nsScreen)
        }
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        sources = NSScreen.screens.map { nsScreen in
            if let existingScreen = sources.first(where: { $0.nsScreen === nsScreen }) {
                return existingScreen
            } else {
                return Screen(screen: nsScreen)
            }
        }

        state = .monitoring
        sourceProviderEventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        guard isUpdating else { return }

        state = .notMonitoring
        sourceProviderEventsSubject.send(.stoppedUpdating())
    }
}
#endif
