/**
 A struct that represents degrees
 */
public struct Degree: NumericUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public let maximumFractionDigits: Int

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = "º"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = "º"

    public init() {
        self.maximumFractionDigits = 0
    }

    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

}
