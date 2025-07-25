#if os(watchOS)
import Combine
import GatheredKit
import WatchKit

/// A wrapper around `WKInterfaceDevice`.
public final class Screen: Source {
    public let availability: SourceAvailability = .available

    public let id: SourceIdentifier

    /// The `WKInterfaceDevice` this `Screen` represents. This will always be `WKInterfaceDevice.current()`
    public let device: WKInterfaceDevice

    /**
     The native resolution of the screen
     */
    @ResolutionPixelsProperty
    public private(set) var resolution: CGSize

    /**
     The native scale factor of the screen
     */
    @BasicProperty
    public private(set) var scale: CGFloat

    /**
     An array of the screen's properties, in the following order:
     - Resolution
     - Scale
     */
    public var allProperties: [any Property] {
        [
            $resolution,
            $scale,
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
        id = SourceIdentifier(sourceKind: .screen)

        _resolution = .init(
            id: id.identifierForChildPropertyWithId("resolution"),
            value: device.screenBounds.size/*,
            unit: .points(screenScale: device.screenScale)*/
        )

        _scale = .init(
            id: id.identifierForChildPropertyWithId("scale"),
            value: device.screenScale
        )
    }
}

#endif
