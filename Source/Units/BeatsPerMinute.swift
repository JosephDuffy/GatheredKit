
/**
 A struct that represents Beats Per Minute (BPS)
 */
public struct BeatsPerMinute: NumberBasedSourcePropertyUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public static let defaultMaximumFractionDigits: Int = 0

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = " BPM"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = " BPM"

    /// The maximum number of digits to show after the decimal place
    public let maximumFractionDigits: Int

    /**
     Create a new instance of the unit
     - parameter maximumFractionDigits: The maximum number of digits to show after the decimal place
     */
    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

}
