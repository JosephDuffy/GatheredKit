#if os(watchOS)
import WatchKit
import Combine

/**
 A wrapper around `WKInterfaceDevice`.
 */
public final class Screen: Source {

    public static var availability: SourceAvailability = .available

    public static var name = "Screen"

    /// The `WKInterfaceDevice` this `Screen` represents. This will always be `WKInterfaceDevice.current()`
    public let device: WKInterfaceDevice

    /**
     The native resolution of the screen
     */
    public let resolution: SizeValue

    /**
     The native scale factor of the screen
     */
    public let scale: ScaleValue

    /**
     An array of the screen's properties, in the following order:
     - Resolution
     - Scale
     */
    public var allProperties: [AnyProperty] {
        return [
            resolution,
            scale,
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

        resolution = SizeValue(
            displayName: "Resolution",
            value: device.screenBounds.size
        )
        resolution.formatter.suffix = " Points"

        scale = ScaleValue(
            displayName: "Scale",
            value: device.screenScale
        )
    }

}

#endif
