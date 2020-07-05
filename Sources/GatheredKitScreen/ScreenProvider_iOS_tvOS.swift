#if os(iOS) || os(tvOS)
import UIKit
import Combine
import GatheredKitCore

public final class ScreenProvider: ControllableSourceProvider {

    private enum State {
        case notMonitoring
        case monitoring(observers: Observers)

        struct Observers {
            let didConnect: NSObjectProtocol
            let didDisconnect: NSObjectProtocol
        }
    }

    public let name = "Screens"

    public var sourceProviderEventsPublisher: AnyUpdatePublisher<SourceProviderEvent<Screen>> {
        sourceProviderEventsSubject.eraseToAnyUpdatePublisher()
    }

    private let sourceProviderEventsSubject: UpdateSubject<SourceProviderEvent<Screen>>

    public var controllableEventUpdatePublisher: AnyUpdatePublisher<ControllableEvent> {
        controllableEventUpdateSubject.eraseToAnyUpdatePublisher()
    }

    private let controllableEventUpdateSubject: UpdateSubject<ControllableEvent>

    public private(set) var sources: [Screen]

    public private(set) var isUpdating: Bool = false

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
        sources = UIScreen.screens.map { uiScreen in
            Screen(screen: uiScreen)
        }
        sourceProviderEventsSubject = .init()
        controllableEventUpdateSubject = .init()
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        let didConnectCancellable = notificationCenter.addObserver(
            forName: UIScreen.didConnectNotification,
            object: nil,
            queue: nil
        ) { [unowned self] notification in
            guard let uiScreen = notification.object as? UIScreen else { return }
            let screen = Screen(screen: uiScreen, notificationCenter: notificationCenter)
            let event = SourceProviderEvent.sourceAdded(screen)
            // TODO: Explcitly insert at correct index
            self.sources = UIScreen.screens.map { uiScreen in
                Screen(screen: uiScreen)
            }
            self.sourceProviderEventsSubject.notifyUpdateListeners(of: event)
        }

        let didDisconnectCancellable = notificationCenter.addObserver(
            forName: UIScreen.didDisconnectNotification,
            object: nil,
            queue: nil
        ) { [unowned self] notification in
            guard let uiScreen = notification.object as? UIScreen else { return }
            let screen = Screen(screen: uiScreen, notificationCenter: notificationCenter)
            let event = SourceProviderEvent.sourceRemoved(screen)
            // TODO: Explcitly remove from index
            self.sources = UIScreen.screens.map { uiScreen in
                Screen(screen: uiScreen)
            }
            self.sourceProviderEventsSubject.notifyUpdateListeners(of: event)
        }

        state = .monitoring(observers: .init(didConnect: didConnectCancellable, didDisconnect: didDisconnectCancellable))
        controllableEventUpdateSubject.notifyUpdateListeners(of: .startedUpdating)
    }

    public func stopUpdating() {
        guard isUpdating else { return }

        state = .notMonitoring
        controllableEventUpdateSubject.notifyUpdateListeners(of: .stoppedUpdating())
    }

}

#endif
