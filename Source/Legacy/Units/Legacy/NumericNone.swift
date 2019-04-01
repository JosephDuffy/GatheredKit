/**
 A special unit that respresents the unit of a value that is numeric, but does not
 have specific unit associated with it
 */
public struct NumericNone: NumericUnit {

    /// The maximum number of digits to allow after the decimal place
    public let maximumFractionDigits: Int

    /// An empty string
    public let singularValueSuffix = ""

    /// An empty string
    public let pluralValueSuffix = ""

    /**
     Creates a new `NumericNone` instance with the `maximumFractionDigits` property set to 2
     */
    public init() {
        maximumFractionDigits = 2
    }

    /**
     - parameter maximumFractionDigits: The maximum number of digits to allow after the decimal place
     */
    public init(maximumFractionDigits: Int) {
        self.maximumFractionDigits = maximumFractionDigits
    }

}
