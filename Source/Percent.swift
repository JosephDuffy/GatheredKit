
/**
 A struct that represents a percentage
 */
public struct Percent: NumberBasedSourcePropertyUnit {

    /// The value for `maximumFractionDigits` that will be used with the empty initialiser
    public let maximumFractionDigits: Int = 2

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    public let singularValueSuffix = "%"

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    public let pluralValueSuffix = "%"

    /**
     Generates a human-friendly string for the given value.

     This will use a `NumberFormatter` with a `numberStyle` of `percent`, meaning that
     values are multiflied by 100 before being formatter, e.g. "0.79" is represented as "79%"

     - parameter value: The value to be formatted. Must be castable to `NSNumber`
     - throws: `SourcePropertyUnitError.unsupportedType` if the `value` cannot be cast to an `NSNumber`
     - returns: The formatted string
     */
    public func formattedString(for value: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = maximumFractionDigits

        return self.formattedString(for: value, usingFormatter: formatter)
    }

}
