import UIKit

/**
 A wrapper around `UIScreen`. Each property is read directly from `UIScreen`; every property is always the latest
 available value
 */
public final class Screen: BaseSource, ControllableSource {

    private enum State {
        case notMonitoring
        case monitoring(brightnessChangeObeserver: NSObjectProtocol, updatesQueue: OperationQueue)
    }

    /**
     Generates and returns a human-friendly string that represents the given size. String will be in the format:

     "\(width) x \(height)"

     Numeric values (width and height) will be formatted using a `NumberFormatter`

     - parameter size: The size to be formatted
     - parameter unit: The unit the size is measured in, usually Point or Pixel

     - returns: The formatted string
     */
    private static func formattedString<Unit: NumericUnit>(for size: CGSize, unit: Unit) -> String {
        let widthString = numberFormatter.string(from: size.width as NSNumber) ?? "\(size.width)"
        let heightString = numberFormatter.string(from: size.height as NSNumber) ?? "\(size.height)"

        return "\(widthString) x \(heightString)" + unit.pluralValueSuffix
    }

    private static var numberFormatter = NumberFormatter()

    public static var availability: SourceAvailability = .available

    public static var displayName = "Screen"

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
    public let reportedResolution: GenericValue<CGSize, Point>

    /**
     The native resolution of the screen
     */
    public let nativeResolution: GenericValue<CGSize, Pixel>

    /**
     The reported scale factor of the screen
     */
    public let reportedScale: GenericValue<CGFloat, Scale>

    /**
     The native scale factor of the screen
     */
    public let nativeScale: GenericValue<CGFloat, Scale>

    /**
     The brightness level of the screen. The value of this property will be a number between
     0.0 and 1.0, inclusive.

     This value will update automatically when `startUpdating` is called
     */
    public private(set) var brightness: GenericValue<CGFloat, Percent>

    /**
     An array of the screen's properties, in the following order:
     - Screen Resolution (reported)
     - Screen Resolution (native)
     - Screen Resolution (reported)
     - Screen Resolution (native)
     - Brightness
     */
    public var allValues: [AnyValue] {
        return [
            reportedResolution.asAny(),
            nativeResolution.asAny(),
            reportedScale.asAny(),
            nativeScale.asAny(),
            brightness.asAny(),
        ]
    }

    /// The internal state, indicating if the screen is monitoring for changes
    private var state: State = .notMonitoring

    public override convenience init() {
        self.init(screen: UIScreen.main as ScreenBackingData)
    }

    public convenience init(screen: UIScreen) {
        self.init(screen: screen as ScreenBackingData)
    }

    /**
     Create a new instance of `Screen` for the given `UIScreen` instance

     - parameter screen: The `UIScreen` to get data from
     */
    internal init(screen: ScreenBackingData) {
        self.screen = screen

        reportedResolution = GenericValue(
            name: "Resolution (reported)",
            backingValue: screen.bounds.size,
            formattedValue: Screen.formattedString(for: screen.bounds.size, unit: Point())
        )

        nativeResolution = GenericValue(
            name: "Resolution (native)",
            backingValue: screen.nativeBounds.size,
            formattedValue: Screen.formattedString(for: screen.nativeBounds.size, unit: Pixel())
        )

        reportedScale = GenericValue(
            name: "Scale (reported)",
            backingValue: screen.scale
        )

        nativeScale = GenericValue(
            name: "Scale (native)",
            backingValue: screen.nativeScale
        )

        brightness = GenericValue(
            name: "Brightness",
            backingValue: screen.brightness
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

        let brightnessChangeObeserver = NotificationCenter.default.addObserver(forName: UIScreen.brightnessDidChangeNotification, object: screen, queue: updatesQueue) { [weak self] _ in
            guard let `self` = self else { return }
            self.brightness.update(backingValue: self.screen.brightness)
            self.notifyListenersPropertyValuesUpdated()
        }

        state = .monitoring(brightnessChangeObeserver: brightnessChangeObeserver, updatesQueue: updatesQueue)
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopUpdating() {
        guard case .monitoring(let brightnessChangeObeserver) = state else { return }

        NotificationCenter.default.removeObserver(brightnessChangeObeserver)

        state = .notMonitoring
    }

}

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
