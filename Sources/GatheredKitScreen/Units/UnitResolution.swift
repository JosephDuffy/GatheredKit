import CoreGraphics
import Foundation

/// Unit of measurement for screen resolution.
public final class UnitResolution: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> UnitResolution {
        pixels
    }

    public static let pixels = UnitResolution(
        symbol: "px", converter: UnitConverterLinear(coefficient: 1)
    )

    public static func points(screenScale: CGFloat) -> UnitResolution {
        UnitResolution(
            symbol: "pt",
            converter: UnitConverterLinear(coefficient: screenScale)
        )
    }
}
