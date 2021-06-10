import Foundation

public final class UnitMagneticField: Dimension {

    public override class func baseUnit() -> UnitMagneticField { return tesla }

    public static let tesla = UnitMagneticField(
        symbol: "T",
        converter: UnitConverterLinear(coefficient: 1)
    )

    public static let microTesla = UnitMagneticField(
        symbol: "µT",
        converter: UnitConverterLinear(coefficient: 1 / 1000)
    )

}
