#if os(iOS) || os(tvOS)
import UIKit
import Combine

/**
 A wrapper around `UIScreen`.
 */
public final class Screen: ControllableSource {

    private enum State {
        case notMonitoring
        #if os(iOS)
        case monitoring(brightnessChangeObeserver: NSObjectProtocol, modeChangeObeserver: NSObjectProtocol, updatesQueue: OperationQueue)
        #elseif os(tvOS)
        case monitoring(modeChangeObeserver: NSObjectProtocol, updatesQueue: OperationQueue)
        #endif
    }

    public static var availability: SourceAvailability = .available

    public static var name = "Screen"

    public let publisher = Publisher()

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
    public let reportedResolution: SizeValue

    /**
     The native resolution of the screen
     */
    public let nativeResolution: SizeValue

    /**
     The reported scale factor of the screen
     */
    public let reportedScale: ScaleValue

    /**
     The native scale factor of the screen
     */
    public let nativeScale: ScaleValue

    #if os(iOS) || os(macOS)
    /**
     The brightness level of the screen. The value of this property will be a number between
     0.0 and 1.0, inclusive.

     This value will update automatically when `startUpdating` is called
     */
    public let brightness: Property<CGFloat, PercentFormatter>
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
        #if os(iOS) || os(macOS)
        return [
            reportedResolution,
            nativeResolution,
            reportedScale,
            nativeScale,
            brightness,
        ]
        #elseif os(tvOS)
        return [
            reportedResolution,
            nativeResolution,
            reportedScale,
            nativeScale,
        ]
        #endif
    }

    private var propertyUpdateCancellables: [AnyCancellable] = []

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
        self.uiScreen = screen
        self.notificationCenter = notificationCenter

        reportedResolution = SizeValue(
            displayName: "Resolution (reported)",
            value: screen.bounds.size
        )
        reportedResolution.formatter.suffix = " Points"

        nativeResolution = SizeValue(
            displayName: "Resolution (native)",
            value: screen.nativeBounds.size
        )
        nativeResolution.formatter.suffix = " Pixels"

        reportedScale = ScaleValue(
            displayName: "Scale (reported)",
            value: screen.scale
        )

        nativeScale = ScaleValue(
            displayName: "Scale (native)",
            value: screen.nativeScale
        )

        #if os(iOS)
        brightness = .init(displayName: "Brightness", value: screen.brightness)
        #endif

        propertyUpdateCancellables = publishUpdateWhenAnyPropertyUpdates()
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
        let brightnessChangeObeserver = notificationCenter.addObserver(forName: UIScreen.brightnessDidChangeNotification, object: uiScreen, queue: updatesQueue) { [weak self] _ in
            guard let self = self else { return }
            self.brightness.updateValueIfDifferent(self.uiScreen.brightness)
        }
        brightness.updateValueIfDifferent(uiScreen.brightness)
        #endif

        let modeChangeObeserver = notificationCenter.addObserver(forName: UIScreen.modeDidChangeNotification, object: uiScreen, queue: updatesQueue) { [weak self] _ in
            guard let self = self else { return }
            self.reportedResolution.updateValueIfDifferent(self.uiScreen.bounds.size)
            self.nativeResolution.updateValueIfDifferent(self.uiScreen.nativeBounds.size)
            self.reportedScale.updateValueIfDifferent(self.uiScreen.scale)
            self.nativeScale.updateValueIfDifferent(self.uiScreen.nativeScale)
        }

        reportedResolution.updateValueIfDifferent(uiScreen.bounds.size)
        nativeResolution.updateValueIfDifferent(uiScreen.nativeBounds.size)
        reportedScale.updateValueIfDifferent(uiScreen.scale)
        nativeScale.updateValueIfDifferent(uiScreen.nativeScale)

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
        
        publisher.send(.startedUpdating)
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopUpdating() {
        #if os(iOS) || os(macOS)
        guard case .monitoring(let brightnessChangeObeserver, let modeChangeObeserver, _) = state else { return }

        notificationCenter
            .removeObserver(
                brightnessChangeObeserver,
                name: UIScreen.brightnessDidChangeNotification,
                object: uiScreen
            )
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
        publisher.send(.stoppedUpdating)
    }

}

#endif
