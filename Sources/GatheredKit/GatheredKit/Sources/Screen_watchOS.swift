#if os(watchOS)
import WatchKit
import Combine

/**
 A wrapper around `WKInterfaceDevice`.
 */
public final class Screen: Source {

    public let availability: SourceAvailability = .available

    public let name = "Screen"

    /// The `WKInterfaceDevice` this `Screen` represents. This will always be `WKInterfaceDevice.current()`
    public let device: WKInterfaceDevice

    /**
     The native resolution of the screen
     */
    @SizeValue
    public private(set) var resolution: CGSize

    /**
     The native scale factor of the screen
     */
    @ScaleValue
    public private(set) var scale: CGFloat

    /**
     An array of the screen's properties, in the following order:
     - Resolution
     - Scale
     */
    public var allProperties: [AnyProperty] {
        return [
            _resolution,
            _scale,
        ]
    }

    /**
    Create a new instance of `Screen` for the `current` `WKInterfaceDevice`.
    */
    public convenience init() {
        self.init(device: .current())
    }

    /**
     Create a new instance of `Screen` for the given `WKInterfaceDevice` instance.

     - Parameter device: The `WKInterfaceDevice` to get data from.
     */
    internal init(device: WKInterfaceDevice) {
        self.device = device

        _resolution = .init(
            displayName: "Resolution",
            value: device.screenBounds.size
        )
        _resolution.formatter.suffix = " Points"

        _scale = .init(
            displayName: "Scale",
            value: device.screenScale
        )
    }

}

#endif
