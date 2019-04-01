/**
 A struct that represents the scaling of something, i.e. a multiplier
 */
public struct Scale: NumericUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public let maximumFractionDigits: Int

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = "x"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = "x"

    public lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = false
        return formatter
    }()

    public init() {
        self.maximumFractionDigits = 0
    }

    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

}
