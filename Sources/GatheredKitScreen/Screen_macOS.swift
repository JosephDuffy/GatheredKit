#if os(macOS)
import AppKit
import Combine
import GatheredKit

/// A wrapper around `NSScreen`.
public final class Screen: UpdatingSource, Controllable {
    private enum State {
        case notMonitoring
        case monitoring(
            screenParametersObserver: NSObjectProtocol, colorSpaceObserver: NSObjectProtocol,
            updatesQueue: OperationQueue
        )
    }

    public let availability: SourceAvailability = .available

    public let name = "Screen"

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    public private(set) var isUpdating: Bool = false

    /// The `NSScreen` this `Screen` represents.
    public let nsScreen: NSScreen

    /**
     The resolution of the screen
     */
    @SizeProperty
    public private(set) var resolution: CGSize

    /**
     An array of the screen's properties, in the following order:
     - Resolution
     */
    public var allProperties: [AnyProperty] {
        [
            $resolution,
        ]
    }

    /// The internal state, indicating if the screen is monitoring for changes
    private var state: State = .notMonitoring {
        didSet {
            switch state {
            case .monitoring:
                isUpdating = true
                eventsSubject.send(.startedUpdating)
            case .notMonitoring:
                isUpdating = false
                eventsSubject.send(.stoppedUpdating())
            }
        }
    }

    private let notificationCenter: NotificationCenter

    /**
     Create a new instance of `Screen` for the `main` `UIScreen`.
     */
    public convenience init?() {
        guard let screen = NSScreen.main else { return nil }
        self.init(screen: screen)
    }

    /**
     Create a new instance of `Screen` for the given `NSScreen` instance

     - Parameter screen: The `NSScreen` to get data from.
     - Parameter notificationCenter: The notification center to listen to notifications from.
     */
    internal init(screen: NSScreen, notificationCenter: NotificationCenter = .default) {
        nsScreen = screen
        self.notificationCenter = notificationCenter

        _resolution = .init(
            displayName: "Resolution",
            value: screen.frame.size
        )
        $resolution.formatter.suffix = " Pixels"
    }

    deinit {
        stopUpdating()
    }

    /**
     Start automatically monitoring changes to the source. This will start delegate methods being called
     when new data is available
     */
    public func startUpdating() {
        guard !isUpdating else { return }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "uk.co.josephduffy.GatheredKit Screen Updates"

        let screenParametersObserver = notificationCenter.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: NSApplication.shared, queue: updatesQueue
        ) { [weak self] _ in
            guard let self = self else { return }

            if let snapshot = self._resolution.updateValueIfDifferent(self.nsScreen.frame.size) {
                self.eventsSubject.send(.propertyUpdated(property: self.$resolution, snapshot: snapshot))
            }
        }

        if let snapshot = _resolution.updateValueIfDifferent(nsScreen.frame.size) {
            eventsSubject.send(.propertyUpdated(property: $resolution, snapshot: snapshot))
        }

        let colorSpaceObserver = notificationCenter.addObserver(
            forName: NSScreen.colorSpaceDidChangeNotification, object: nsScreen, queue: updatesQueue
        ) { _ in
            // TODO: Update colour space
        }

        state = .monitoring(
            screenParametersObserver: screenParametersObserver,
            colorSpaceObserver: colorSpaceObserver,
            updatesQueue: updatesQueue
        )
        eventsSubject.send(.startedUpdating)
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopUpdating() {
        guard case .monitoring(let screenParametersObserver, let colorSpaceObserver, _) = state
        else { return }

        notificationCenter
            .removeObserver(
                screenParametersObserver,
                name: NSApplication.didChangeScreenParametersNotification,
                object: NSApplication.shared
            )

        notificationCenter
            .removeObserver(
                colorSpaceObserver,
                name: NSScreen.colorSpaceDidChangeNotification,
                object: nsScreen
            )

        state = .notMonitoring
        eventsSubject.send(.stoppedUpdating())
    }
}

#endif
