/**
 A struct that represents Beats Per Minute (BPS)
 */
public struct BeatsPerMinute: NumericUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public let maximumFractionDigits: Int = 0

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " BPM"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " BPM"

    public init() { }

}
