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
            brightnessChangeObeserver: NSObjectProtocol?, modeChangeObeserver: NSObjectProtocol,
            updatesQueue: OperationQueue
        )
        #elseif os(tvOS)
        case monitoring(modeChangeObeserver: NSObjectProtocol, updatesQueue: OperationQueue)
        #endif
    }

    public let availability: SourceAvailability = .available

    public let name: String

    public var sourceEventPublisher: AnyUpdatePublisher<SourceEvent> {
        sourceEventsSubject.eraseToAnyUpdatePublisher()
    }

    private let sourceEventsSubject: UpdateSubject<SourceEvent>

    /// A boolean indicating if the screen is monitoring for brightness changes
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    /// The `UIScreen` this `Screen` represents.
    public let uiScreen: UIScreen

    /**
     The reported resolution of the screen
     */
    @SizeProperty
    public private(set) var reportedResolution: CGSize

    /**
     The native resolution of the screen
     */
    @SizeProperty
    public private(set) var nativeResolution: CGSize

    /**
     The reported scale factor of the screen
     */
    @ScaleProperty
    public private(set) var reportedScale: CGFloat

    /**
     The native scale factor of the screen
     */
    @ScaleProperty
    public private(set) var nativeScale: CGFloat

    #if os(iOS)
    /**
     The brightness level of the screen. The value of this property will be a number between
     0.0 and 1.0, inclusive.

     If the screen is not the main screen this value will always be 1.
     */
    @PercentProperty
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
    public var allProperties: [AnyProperty] {
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
    private var state: State = .notMonitoring

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
        name = screen == .main ? "Main" : "External"
        uiScreen = screen
        self.notificationCenter = notificationCenter

        _reportedResolution = .init(
            displayName: "Resolution (reported)",
            value: screen.bounds.size
        )

        _nativeResolution = .init(
            displayName: "Resolution (native)",
            value: screen.nativeBounds.size
        )

        _reportedScale = .init(
            displayName: "Scale (reported)",
            value: screen.scale
        )

        _nativeScale = .init(
            displayName: "Scale (native)",
            value: screen.nativeScale
        )

        #if os(iOS)
        let brightness = screen == .main ? screen.brightness : 1
        _brightness = .init(displayName: "Brightness", value: brightness)
        #endif

        sourceEventsSubject = .init()

        $reportedResolution.formatter.suffix = " Points"
        $nativeResolution.formatter.suffix = " Pixels"
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

        #if os(iOS)
        let brightnessChangeObeserver: NSObjectProtocol?

        if uiScreen == .main {
            brightnessChangeObeserver = notificationCenter.addObserver(
                forName: UIScreen.brightnessDidChangeNotification,
                object: uiScreen,
                queue: updatesQueue
            ) { [weak self] _ in
                guard let self = self else { return }

                if let snapshot = self._brightness.updateValueIfDifferent(self.uiScreen.brightness) {
                    self.sourceEventsSubject.notifyUpdateListeners(
                        of: .propertyUpdated(
                            property: self.$brightness,
                            snapshot: snapshot
                        )
                    )
                }
            }

            if let snapshot = _brightness.updateValueIfDifferent(uiScreen.brightness) {
                sourceEventsSubject.notifyUpdateListeners(of: .propertyUpdated(property: $brightness, snapshot: snapshot))
            }
        } else {
            brightnessChangeObeserver = nil
        }
        #endif

        let modeChangeObeserver = notificationCenter.addObserver(
            forName: UIScreen.modeDidChangeNotification, object: uiScreen, queue: updatesQueue
        ) { [weak self] _ in
            guard let self = self else { return }
            if let snapshot = self._reportedResolution.updateValueIfDifferent(self.uiScreen.bounds.size) {
                self.sourceEventsSubject.notifyUpdateListeners(
                    of: .propertyUpdated(
                        property: self.$reportedResolution,
                        snapshot: snapshot
                    )
                )
            }
            if let snapshot = self._nativeResolution.updateValueIfDifferent(self.uiScreen.nativeBounds.size) {
                self.sourceEventsSubject.notifyUpdateListeners(
                    of: .propertyUpdated(
                        property: self.$nativeResolution,
                        snapshot: snapshot
                    )
                )
            }
            if let snapshot = self._reportedScale.updateValueIfDifferent(self.uiScreen.scale) {
                self.sourceEventsSubject.notifyUpdateListeners(
                    of: .propertyUpdated(
                        property: self.$reportedResolution,
                        snapshot: snapshot
                    )
                )
            }
            if let snapshot = self._nativeScale.updateValueIfDifferent(self.uiScreen.nativeScale) {
                self.sourceEventsSubject.notifyUpdateListeners(
                    of: .propertyUpdated(
                        property: self.$nativeScale,
                        snapshot: snapshot
                    )
                )
            }
        }

        _reportedResolution.updateValueIfDifferent(uiScreen.bounds.size)
        _nativeResolution.updateValueIfDifferent(uiScreen.nativeBounds.size)
        _reportedScale.updateValueIfDifferent(uiScreen.scale)
        _nativeScale.updateValueIfDifferent(uiScreen.nativeScale)

        #if os(iOS)
        state = .monitoring(
            brightnessChangeObeserver: brightnessChangeObeserver,
            modeChangeObeserver: modeChangeObeserver,
            updatesQueue: updatesQueue
        )
        #elseif os(tvOS)
        state = .monitoring(
            modeChangeObeserver: modeChangeObeserver,
            updatesQueue: updatesQueue
        )
        #endif

        sourceEventsSubject.notifyUpdateListeners(of: .startedUpdating)
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopUpdating() {
        #if os(iOS)
        guard case .monitoring(let brightnessChangeObeserver, let modeChangeObeserver, _) = state
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
        guard case .monitoring(let modeChangeObeserver, _) = state else { return }
        #endif

        notificationCenter
            .removeObserver(
                modeChangeObeserver,
                name: UIScreen.modeDidChangeNotification,
                object: uiScreen
            )

        state = .notMonitoring
        sourceEventsSubject.notifyUpdateListeners(of: .stoppedUpdating())
    }
}

#endif
