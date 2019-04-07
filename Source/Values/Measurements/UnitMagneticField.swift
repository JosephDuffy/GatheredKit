import Foundation

open class UnitMagneticField: Dimension {
    
    public static let baseUnit = tesla
 
    public static let tesla = UnitMagneticField(symbol: "T", converter: UnitConverterLinear(coefficient: 1))
    
    public static let microTesla = UnitMagneticField(symbol: "µT", converter: UnitConverterLinear(coefficient: 1/1000))
    
}
