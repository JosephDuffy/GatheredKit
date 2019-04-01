/**
 A struct that represents meters
 */
public struct MetersPerSecond: NumericUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public let maximumFractionDigits: Int

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " m/s"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " m/s"

    public init() {
        self.maximumFractionDigits = 2
    }

    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

}
