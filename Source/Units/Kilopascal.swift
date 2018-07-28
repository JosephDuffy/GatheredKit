
/**
 A struct that represents kilopascals
 */
public struct Kilopascal: NumericUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public let maximumFractionDigits: Int = 2

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " kPa"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " kPa"

    public init() {}

}
