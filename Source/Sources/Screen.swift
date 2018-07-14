import UIKit

/**
 A wrapper around `UIScreen`. Each property is read directly from `UIScreen`; every property is always the latest
 available value
 */
public final class Screen: BaseSource, ControllableSource {

    private enum State {
        case notMonitoring
        case monitoring(brightnessChangeObeserver: NSObjectProtocol)
    }

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
     The screen resolution reported by the system
     **Properties**
     Display name: Screen Resolution (reported)
     Unit: Point

     Formatted value: "\(width) x \(height) Points"
     */
    public var reportedResolution: GenericValue<CGSize, Point> {
        let unit = Point()

        return GenericValue(
            name: "Resolution (reported)",
            backingValue: screen.bounds.size,
            formattedValue: formattedString(for: screen.bounds.size) + unit.pluralValueSuffix,
            unit: unit
        )
    }

    /**
     The native resolution of the screen

     **Properties**
     Display name: Screen Resolution (native)
     Unit: Pixel
     Formatted value: "\(width) x \(height) Pixels"
     */
    public var nativeResolution: GenericValue<CGSize, Pixel> {
        let unit = Pixel()

        return GenericValue(
            name: "Resolution (native)",
            backingValue: screen.nativeBounds.size,
            formattedValue: formattedString(for: screen.nativeBounds.size) + unit.pluralValueSuffix,
            unit: unit
        )
    }

    /**
     The natural scale factor associated with the screen

     **Properties**
     Display name: Screen Scale (reported)
     */
    public var reportedScale: GenericValue<CGFloat, Scale> {
        return GenericValue(
            name: "Scale (reported)",
            backingValue: screen.scale,
            unit: Scale()
        )
    }

    /**
     The native scale factor for the physical screen

     **Properties**

     Display name: Screen Scale (native)
     */
    public var nativeScale: GenericValue<CGFloat, Scale> {
        return GenericValue(
            name: "Scale (native)",
            backingValue: screen.nativeScale,
            unit: Scale()
        )
    }

    /**
     The brightness level of the screen. The value of this property will be a number between
     0.0 and 1.0, inclusive
     **Properties**

     Display name: Brightness

     Unit: Percent
     */
    public var brightness: GenericValue<CGFloat, Percent> {
        return GenericValue(
            name: "Brightness",
            backingValue: screen.brightness,
            unit: Percent()
        )
    }

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

        let brightnessChangeObeserver = NotificationCenter.default.addObserver(forName: .UIScreenBrightnessDidChange, object: screen, queue: .main) { [weak self] _ in
            self?.notifyListenersPropertyValuesUpdated()
        }

        state = .monitoring(brightnessChangeObeserver: brightnessChangeObeserver)
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopUpdating() {
        guard case .monitoring(let brightnessChangeObeserver) = state else { return }

        NotificationCenter.default.removeObserver(brightnessChangeObeserver)

        state = .notMonitoring
    }

    /**
     Generates and returns a human-friendly string that represents the given size. String will be in the format:

     "\(width) x \(height)"

     Numeric values (width and height) will be formatted using a `NumberFormatter`

     - parameter size: The size to be formatted

     - returns: The formatted string
     */
    internal func formattedString(for size: CGSize) -> String {
        let formatter = NumberFormatter()
        let widthString = formatter.string(from: size.width as NSNumber) ?? "\(size.width)"
        let heightString = formatter.string(from: size.height as NSNumber) ?? "\(size.height)"

        return "\(widthString) x \(heightString)"
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
