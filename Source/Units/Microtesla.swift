
/**
 A struct that represents microteslas
 */
public struct Microtesla: NumericUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public let maximumFractionDigits: Int = 2

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " µT"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " µT"

    public init() {}

}
