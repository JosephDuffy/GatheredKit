#if os(iOS) || os(tvOS)
import UIKit
import Combine

public final class ScreenProvider: ControllableSourceProvider {

    private enum State {
        case notMonitoring
        case monitoring(observers: Observers)

        struct Observers {
            let didConnect: AnyCancellable
            let didDisconnect: AnyCancellable
        }
    }
    
    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return controllableEventsSubject.eraseToAnyPublisher()
    }

    public let controllableEventsSubject = PassthroughSubject<ControllableEvent, ControllableError>()
    
    public var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<Screen>, Never> {
        return sourceProviderEventsSubject.eraseToAnyPublisher()
    }

    private let sourceProviderEventsSubject = PassthroughSubject<SourceProviderEvent<Screen>, Never>()

    @Published
    public private(set) var sources: [Screen]

    @Published
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
        sources = UIScreen.screens.map { Screen(screen: $0) }
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        let didConnectCancellable = notificationCenter
            .publisher(for: UIScreen.didConnectNotification)
            .map(\Notification.object)
            .compactMap { $0 as? UIScreen }
            .map { Screen(screen: $0) }
            .map { SourceProviderEvent.sourceAdded($0) }
            .sink(receiveValue: sourceProviderEventsSubject.send(_:))

        let didDisconnectCancellable = notificationCenter
            .publisher(for: UIScreen.didDisconnectNotification)
            .map(\Notification.object)
            .compactMap { $0 as? UIScreen }
            .map { Screen(screen: $0) }
            .map { SourceProviderEvent.sourceRemoved($0) }
            .sink(receiveValue: sourceProviderEventsSubject.send(_:))

        state = .monitoring(observers: .init(didConnect: didConnectCancellable, didDisconnect: didDisconnectCancellable))
        controllableEventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        guard isUpdating else { return }

        state = .notMonitoring
        controllableEventsSubject.send(.stoppedUpdating)
    }

}

#endif
