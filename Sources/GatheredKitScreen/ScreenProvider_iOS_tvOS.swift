#if os(iOS) || os(tvOS)
import Combine
import GatheredKit
import UIKit

public final class ScreenProvider: UpdatingSourceProvider, ControllableSourceProvider {
    private enum State {
        case notMonitoring
        case monitoring(observers: Observers)

        struct Observers {
            let didConnect: NSObjectProtocol
            let didDisconnect: NSObjectProtocol
        }
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
        id = SourceProviderIdentifier(sourceKind: .screen)
        self.notificationCenter = notificationCenter
        sources = UIScreen.screens.map { uiScreen in
            Screen(screen: uiScreen)
        }
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        let didConnectCancellable = notificationCenter.addObserver(
            forName: UIScreen.didConnectNotification,
            object: nil,
            queue: nil
        ) { [unowned self] notification in
            guard let uiScreen = notification.object as? UIScreen else { return }
            MainActor.assumeIsolated {
                let screen = Screen(screen: uiScreen, notificationCenter: self.notificationCenter)
                let event = SourceProviderEvent.sourceAdded(screen)

                if self.sources.count == UIScreen.screens.count - 1,
                   let insertedIndex = UIScreen.screens.firstIndex(of: uiScreen)
                {
                    self.sources.insert(screen, at: insertedIndex)
                } else {
                    self.sources.append(screen)
                }

                self.sourceProviderEventsSubject.send(event)
            }
        }

        let didDisconnectCancellable = notificationCenter.addObserver(
            forName: UIScreen.didDisconnectNotification,
            object: nil,
            queue: nil
        ) { [unowned self] notification in
            guard let uiScreen = notification.object as? UIScreen else { return }
            MainActor.assumeIsolated {
                guard let index = self.sources.firstIndex(where: { $0.uiScreen == uiScreen }) else {
                    return
                }
                let screen = self.sources.remove(at: index)

                let event = SourceProviderEvent.sourceRemoved(screen)
                self.sourceProviderEventsSubject.send(event)
            }
        }

        sources = UIScreen.screens.map { uiScreen in
            if let existingScreen = sources.first(where: { $0.uiScreen === uiScreen }) {
                return existingScreen
            } else {
                return Screen(screen: uiScreen)
            }
        }

        state = .monitoring(
            observers: .init(
                didConnect: didConnectCancellable, didDisconnect: didDisconnectCancellable
            ))
        sourceProviderEventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        guard isUpdating else { return }

        state = .notMonitoring
        sourceProviderEventsSubject.send(.stoppedUpdating())
    }
}

#endif
