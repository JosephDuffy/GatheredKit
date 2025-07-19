#if os(macOS)
import AppKit
import Combine
import GatheredKit

/// A wrapper around `NSScreen`.
@MainActor
public final class Screen: UpdatingSource, Controllable {
    private enum State {
        case notMonitoring
        case monitoring(notificationCancellables: Set<AnyCancellable>)
    }

    public static var main: Screen? {
        NSScreen.main.map { Screen(screen: $0) }
    }

    public let id: SourceIdentifier

    public let availability: SourceAvailability = .available

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    @Published
    public private(set) var isUpdating: Bool = false

    public var isUpdatingPublisher: AnyPublisher<Bool, Never> {
        $isUpdating.eraseToAnyPublisher()
    }

    /// The `NSScreen` this `Screen` represents.
    public let nsScreen: NSScreen

    /**
     The resolution of the screen
     */
    @ResolutionPixelsProperty
    public private(set) var resolution: CGSize

    /**
     The colour space of the screen.
     */
    @OptionalNSColorSpaceProperty
    public private(set) var colorSpace: NSColorSpace?

    /**
     An array of the screen's properties, in the following order:
     - Resolution
     */
    public var allProperties: [any Property] {
        [
            $resolution,
            $colorSpace,
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
        let screenNumberKey = NSDeviceDescriptionKey("NSScreenNumber")
        if
            let displayId = screen.deviceDescription[screenNumberKey] as? UInt32,
            let displayUUID = CGDisplayCreateUUIDFromDisplayID(displayId)?.takeRetainedValue()
        {
            let uuidString = String(CFUUIDCreateString(nil, displayUUID))
            id = SourceIdentifier(
                sourceKind: .screen,
                instanceIdentifier: uuidString,
                isTransient: false
            )
        } else {
            id = SourceIdentifier(
                sourceKind: .screen,
                instanceIdentifier: "",
                isTransient: true
            )
        }

        nsScreen = screen
        self.notificationCenter = notificationCenter

        _resolution = .init(
            id: id.identifierForChildPropertyWithId("resolution"),
            value: screen.frame.size
        )
        _colorSpace = .init(
            id: id.identifierForChildPropertyWithId("colourSpace"),
            value: screen.colorSpace
        )
    }

    /**
     Start automatically monitoring changes to the source. This will start delegate methods being called
     when new data is available
     */
    public func startUpdating() {
        guard !isUpdating else { return }

        var notificationCancellables: Set<AnyCancellable> = []

        _resolution.updateValueIfDifferent(nsScreen.frame.size)
        _colorSpace.updateValueIfDifferent(nsScreen.colorSpace)

        notificationCenter
            .publisher(
                for: NSApplication.didChangeScreenParametersNotification,
                object: NSApplication.shared
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self._resolution.updateValueIfDifferent(self.nsScreen.frame.size)
            }
            .store(in: &notificationCancellables)

        notificationCenter
            .publisher(
                for: NSScreen.colorSpaceDidChangeNotification,
                object: nsScreen
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self._colorSpace.updateValue(self.nsScreen.colorSpace)
            }
            .store(in: &notificationCancellables)

        notificationCenter.addObserver(
            forName: NSScreen.colorSpaceDidChangeNotification,
            object: nsScreen,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }

            MainActor.assumeIsolated { () -> Void in
                self._colorSpace.updateValue(self.nsScreen.colorSpace)
            }
        }

        state = .monitoring(notificationCancellables: notificationCancellables)
        eventsSubject.send(.startedUpdating)
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopUpdating() {
        guard case .monitoring = state else { return }

        state = .notMonitoring
        eventsSubject.send(.stoppedUpdating())
    }
}

#endif
