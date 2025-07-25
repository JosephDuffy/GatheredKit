#if os(iOS) || os(tvOS)
import Combine
import GatheredKit
import UIKit

/// A wrapper around `UIScreen`.
public final class Screen: UpdatingSource, Controllable {
    private enum State {
        case notMonitoring
        // swiftlint:disable duplicate_enum_cases
        #if os(iOS)
        case monitoring(
            brightnessChangeObeserver: NSObjectProtocol?,
            modeChangeObeserver: NSObjectProtocol,
        )
        #elseif os(tvOS)
        case monitoring(modeChangeObeserver: NSObjectProtocol)
        #endif
    }

    public static var main: Screen {
        Screen(screen: .main)
    }

    public let availability: SourceAvailability = .available

    public let id: SourceIdentifier

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

    /// The `UIScreen` this `Screen` represents.
    public let uiScreen: UIScreen

    /**
     The reported resolution of the screen
     */
    @ResolutionPixelsProperty
    public private(set) var reportedResolution: CGSize

    /**
     The native resolution of the screen
     */
    @ResolutionPixelsProperty
    public private(set) var nativeResolution: CGSize

    /**
     The reported scale factor of the screen
     */
    @BasicProperty
    public private(set) var reportedScale: CGFloat

    /**
     The native scale factor of the screen
     */
    @BasicProperty
    public private(set) var nativeScale: CGFloat

    #if os(iOS)
    /**
     The brightness level of the screen. The value of this property will be a number between
     0.0 and 1.0, inclusive.

     If the screen is not the main screen this value will always be 1.
     */
    @BasicProperty
    public private(set) var brightness: CGFloat
    #endif

    /**
     An array of the screen's properties, in the following order:
     - Screen Resolution (reported)
     - Screen Resolution (native)
     - Screen Resolution (reported)
     - Screen Resolution (native)
     - Brightness
     */
    public var allProperties: [any Property] {
        #if os(iOS)
        return [
            $reportedResolution,
            $nativeResolution,
            $reportedScale,
            $nativeScale,
            $brightness,
        ]
        #elseif os(tvOS)
        return [
            $reportedResolution,
            $nativeResolution,
            $reportedScale,
            $nativeScale,
        ]
        #endif
    }

    /// The internal state, indicating if the screen is monitoring for changes
    private var state: State = .notMonitoring {
        didSet {
            switch state {
            case .notMonitoring:
                isUpdating = false
            case .monitoring:
                isUpdating = true
            }
        }
    }

    private let notificationCenter: NotificationCenter

    /**
     Create a new instance of `Screen` for the `main` `UIScreen`.
     */
    public convenience init() {
        self.init(screen: UIScreen.main)
    }

    /**
     Create a new instance of `Screen` for the given `UIScreen` instance

     - Parameter screen: The `UIScreen` to get data from.
     - Parameter notificationCenter: The notification center to list to notifications from.
     */
    internal init(screen: UIScreen, notificationCenter: NotificationCenter = .default) {
        if screen == .main {
            id = SourceIdentifier(sourceKind: .screen, instanceIdentifier: "main", isTransient: false)
        } else {
            id = SourceIdentifier(sourceKind: .screen, instanceIdentifier: "external", isTransient: true)
        }
        uiScreen = screen
        self.notificationCenter = notificationCenter

        _reportedResolution = ResolutionPixelsProperty(
            id: id.identifierForChildPropertyWithId("reportedResolution"),
            value: screen.bounds.size
        )

        _nativeResolution = ResolutionPixelsProperty(
            id: id.identifierForChildPropertyWithId("nativeResolution"),
            value: screen.nativeBounds.size
        )

        _reportedScale = .init(
            id: id.identifierForChildPropertyWithId("reportedScale"),
            value: screen.scale
        )

        _nativeScale = .init(
            id: id.identifierForChildPropertyWithId("nativeScale"),
            value: screen.nativeScale
        )

        #if os(iOS)
        let brightness = screen == .main ? screen.brightness : 1
        _brightness = .init(
            id: id.identifierForChildPropertyWithId("brightness"),
            value: brightness
        )
        #endif
    }

    /**
     Start automatically monitoring changes to the source. This will start delegate methods being called
     when new data is available
     */
    public func startUpdating() {
        guard !isUpdating else { return }

        #if os(iOS)
        let brightnessChangeObeserver: NSObjectProtocol?

        if uiScreen == .main {
            brightnessChangeObeserver = notificationCenter.addObserver(
                forName: UIScreen.brightnessDidChangeNotification,
                object: uiScreen,
                queue: nil
            ) { [weak self] _ in
                MainActor.assumeIsolated {
                    guard let self else { return }

                    self._brightness.updateValueIfDifferent(self.uiScreen.brightness)
                }
            }

            _brightness.updateValueIfDifferent(uiScreen.brightness)
        } else {
            brightnessChangeObeserver = nil
        }
        #endif

        let modeChangeObeserver = notificationCenter.addObserver(
            forName: UIScreen.modeDidChangeNotification,
            object: uiScreen,
            queue: nil
        ) { [weak self] _ in
            MainActor.assumeIsolated {
                guard let self else { return }
                self._reportedResolution.updateValue(self.uiScreen.bounds.size)
                self._nativeResolution.updateValue(self.uiScreen.nativeBounds.size)
                self._reportedScale.updateValueIfDifferent(self.uiScreen.scale)
                self._nativeScale.updateValueIfDifferent(self.uiScreen.nativeScale)
            }
        }

        _reportedResolution.updateValue(uiScreen.bounds.size)
        _nativeResolution.updateValue(uiScreen.nativeBounds.size)
        _reportedScale.updateValueIfDifferent(uiScreen.scale)
        _nativeScale.updateValueIfDifferent(uiScreen.nativeScale)

        #if os(iOS)
        state = .monitoring(
            brightnessChangeObeserver: brightnessChangeObeserver,
            modeChangeObeserver: modeChangeObeserver
        )
        #elseif os(tvOS)
        state = .monitoring(modeChangeObeserver: modeChangeObeserver)
        #endif

        eventsSubject.send(.startedUpdating)
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopUpdating() {
        #if os(iOS)
        guard case .monitoring(let brightnessChangeObeserver, let modeChangeObeserver) = state
        else { return }

        brightnessChangeObeserver.map { brightnessChangeObeserver in
            notificationCenter
                .removeObserver(
                    brightnessChangeObeserver,
                    name: UIScreen.brightnessDidChangeNotification,
                    object: uiScreen
                )
        }
        #elseif os(tvOS)
        guard case .monitoring(let modeChangeObeserver) = state else { return }
        #endif

        notificationCenter
            .removeObserver(
                modeChangeObeserver,
                name: UIScreen.modeDidChangeNotification,
                object: uiScreen
            )

        state = .notMonitoring
        eventsSubject.send(.stoppedUpdating())
    }
}

#endif
