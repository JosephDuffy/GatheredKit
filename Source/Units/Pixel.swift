
/**
 A struct that represents a screen's pixels
 */
public struct Pixel: NumericUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public let maximumFractionDigits: Int = 0

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " Pixel"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " Pixels"

}
