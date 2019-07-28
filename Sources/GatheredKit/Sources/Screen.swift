#if canImport(UIKit)
import UIKit

/**
 A wrapper around `UIScreen`. Each property is read directly from `UIScreen`; every property is always the latest
 available value
 */
public final class Screen: Source, Controllable, Producer, PropertiesProvider {
    
    public typealias ProducedValue = [AnyProperty]
    
    private enum State {
        case notMonitoring
        case monitoring(brightnessChangeObeserver: NSObjectProtocol, updatesQueue: OperationQueue)
    }

    private static var numberFormatter = NumberFormatter()

    public static var availability: SourceAvailability = .available

    public static var name = "Screen"

    /// A boolean indicating if the screen is monitoring for brightness changes
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }
    
    /// The `ScreenBackingData` this `Screen` represents
    private let screen: ScreenBackingData

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

    /**
     The brightness level of the screen. The value of this property will be a number between
     0.0 and 1.0, inclusive.

     This value will update automatically when `startUpdating` is called
     */
    public var brightness: PercentValue {
        return PercentValue(displayName: "Brightness", value: screen.brightness.native)
    }

    /**
     An array of the screen's properties, in the following order:
     - Screen Resolution (reported)
     - Screen Resolution (native)
     - Screen Resolution (reported)
     - Screen Resolution (native)
     - Brightness
     */
    public var allProperties: [AnyProperty] {
        return [
            reportedResolution,
            nativeResolution,
            reportedScale,
            nativeScale,
            brightness,
        ]
    }
    
    internal var consumers: [AnyConsumer] = []

    /// The internal state, indicating if the screen is monitoring for changes
    private var state: State = .notMonitoring
    
    private let notificationCenter: NotificationCenter

    public convenience init() {
        self.init(screen: UIScreen.main as ScreenBackingData)
    }

    public convenience init(screen: UIScreen) {
        self.init(screen: screen as ScreenBackingData)
    }

    /**
     Create a new instance of `Screen` for the given `UIScreen` instance

     - parameter screen: The `UIScreen` to get data from
     */
    internal init(screen: ScreenBackingData, notificationCenter: NotificationCenter = .default) {
        self.screen = screen
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
            value: screen.scale.native
        )

        nativeScale = ScaleValue(
            displayName: "Scale (native)",
            value: screen.nativeScale.native
        )
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

        let brightnessChangeObeserver = notificationCenter.addObserver(forName: UIScreen.brightnessDidChangeNotification, object: screen, queue: updatesQueue) { [weak self] _ in
            guard let `self` = self else { return }
            self.notifyUpdateConsumersOfLatestValues()
        }

        state = .monitoring(brightnessChangeObeserver: brightnessChangeObeserver, updatesQueue: updatesQueue)
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopUpdating() {
        guard case .monitoring(let brightnessChangeObeserver) = state else { return }

        NotificationCenter
            .default
            .removeObserver(
                brightnessChangeObeserver,
                name: UIScreen.brightnessDidChangeNotification,
                object: screen
            )

        state = .notMonitoring
    }

}

extension Screen: ConsumersProvider { }

/**
 The backing data for the `Screen` source. `UIScreen` conforms to this without any changes
 */
internal protocol ScreenBackingData {

    /// Bounds of entire screen in points
    var bounds: CGRect { get }

    /// The natural scale factor associated with the screen.
    var scale: CGFloat { get }

    /// Native bounds of the physical screen in pixels
    var nativeBounds: CGRect { get }

    /// Native scale factor of the physical screen
    var nativeScale: CGFloat { get }

    /// 0 ... 1.0, where 1.0 is maximum brightness
    var brightness: CGFloat { get }

}

extension UIScreen: ScreenBackingData {}
#endif
