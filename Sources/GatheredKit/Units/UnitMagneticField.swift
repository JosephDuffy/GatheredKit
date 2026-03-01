import Foundation

public final class UnitMagneticField: Dimension, @unchecked Sendable {
    public override class func baseUnit() -> UnitMagneticField {
        tesla
    }

    public static let tesla = UnitMagneticField(
        symbol: "T", converter: UnitConverterLinear(coefficient: 1)
    )

    public static let microTesla = UnitMagneticField(
        symbol: "µT", converter: UnitConverterLinear(coefficient: 1e-9)
    )
}
