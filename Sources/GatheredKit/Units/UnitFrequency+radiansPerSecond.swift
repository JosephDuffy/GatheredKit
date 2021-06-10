import Foundation

extension UnitFrequency {

    public static var radiansPerSecond: UnitFrequency {
        return UnitFrequency(
            symbol: "rad/s", converter: UnitConverterLinear(coefficient: 2 * Double.pi))
    }

}
