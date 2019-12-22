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

    public typealias ProvidedSource = Screen

    public let publisher = PassthroughSubject<SourceProviderEvent<ProvidedSource>, Never>()

    public var sources: [Screen] {
        return UIScreen.screens.map { Screen(screen: $0) }
    }

    public var isUpdating: Bool {
        switch state {
        case .monitoring:
            return true
        case .notMonitoring:
            return false
        }
    }

    private var state: State = .notMonitoring

    private let notificationCenter: NotificationCenter

    public init() {
        self.notificationCenter = .default
    }

    internal init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        let didConnectCancellable = notificationCenter
            .publisher(for: UIScreen.didConnectNotification)
            .map(\Notification.object)
            .compactMap { $0 as? UIScreen }
            .map { Screen(screen: $0) }
            .map { SourceProviderEvent.sourceAdded($0) }
            .sink(receiveValue: publisher.send(_:))

        let didDisconnectCancellable = notificationCenter
            .publisher(for: UIScreen.didDisconnectNotification)
            .map(\Notification.object)
            .compactMap { $0 as? UIScreen }
            .map { Screen(screen: $0) }
            .map { SourceProviderEvent.sourceRemoved($0) }
            .sink(receiveValue: publisher.send(_:))

        state = .monitoring(observers: .init(didConnect: didConnectCancellable, didDisconnect: didDisconnectCancellable))
        publisher.send(.startedUpdating)
    }

    public func stopUpdating() {
        guard isUpdating else { return }

        state = .notMonitoring
        publisher.send(.stoppedUpdating)
    }

}

#endif
