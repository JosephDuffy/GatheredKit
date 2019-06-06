import Foundation

/**
 A unit of measurement that is usually associated to a number.
 */
public protocol NumericUnit: Unit where ValueType == NSNumber {

    /// The maximum number of digits to allow after the decimal place
    var maximumFractionDigits: Int { get }

    /// The string that will be appended to the end of the string when
    /// the value does equal 1
    var singularValueSuffix: String { get }

    /// The string that will be appended to the end of the string when
    /// the value does not equal 1
    var pluralValueSuffix: String { get }

    init(maximumFractionDigits: Int)

}

public extension NumericUnit {

    /**
     Generates a human-friendly string for the given value.
     This will call `formattedString(for:usingFormatter:)` with a formatter configured using the value
     of `self.maximumFractionDigits`
     
     - parameter value: The value to be formatted
     - returns: The formatted string
     */
    public func formattedString(for value: NSNumber) -> String {
        return formattedString(
            for: value,
            maximumFractionDigits: maximumFractionDigits
        )
    }

    /**
     Uses the supplied formatter and value to create a human-friendly string. The suffix will be `singularValueSuffix`
     if `value` is 1, or `pluralValueSuffix` otherwise

     - parameter value: The value to be formatted
     - parameter formatter: The formatter to use to format the numeric value
     - returns: The formatted string
     */
    public func formattedString(
        for value: NSNumber,
        maximumFractionDigits: Int
    ) -> String {
        return formattedString(
            for: value,
            maximumFractionDigits: maximumFractionDigits,
            singularValueSuffix: singularValueSuffix,
            pluralValueSuffix: pluralValueSuffix
        )
    }

    /**
     Uses the supplied formatter and value to create a human-friendly string. The suffix will be `singularValueSuffix`
     if `value` is 1, or `pluralValueSuffix` otherwise

     - parameter value: The value to be formatted
     - parameter formatter: The formatter to use to format the numeric value
     - returns: The formatted string
     */
    public func formattedString(
        for value: NSNumber,
        singularValueSuffix: String,
        pluralValueSuffix: String
    ) -> String {
        return formattedString(
            for: value,
            maximumFractionDigits: maximumFractionDigits,
            singularValueSuffix: singularValueSuffix,
            pluralValueSuffix: pluralValueSuffix
        )
    }

    /**
     Uses the supplied formatter and value to create a human-friendly string. The suffix will be `singularValueSuffix`
     if `value` is 1, or `pluralValueSuffix` otherwise

     - parameter value: The value to be formatted
     - parameter formatter: The formatter to use to format the numeric value
     - returns: The formatted string
     */
    public func formattedString(
        for value: NSNumber,
        maximumFractionDigits: Int,
        singularValueSuffix: String,
        pluralValueSuffix: String
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = maximumFractionDigits > 0 ? .decimal : .none
        formatter.maximumFractionDigits = maximumFractionDigits

        return self.formattedString(
            for: value,
            usingFormatter: formatter,
            singularValueSuffix: singularValueSuffix,
            pluralValueSuffix: pluralValueSuffix
        )
    }

    /**
     Uses the supplied formatter and value to create a human-friendly string. The suffix will be `singularValueSuffix`
     if `value` is 1, or `pluralValueSuffix` otherwise

     - parameter value: The value to be formatted
     - parameter formatter: The formatter to use to format the numeric value
     - returns: The formatted string
     */
    public func formattedString(
        for value: NSNumber,
        usingFormatter formatter: NumberFormatter
    ) -> String {
        return formattedString(
            for: value,
            usingFormatter: formatter,
            singularValueSuffix: singularValueSuffix,
            pluralValueSuffix: pluralValueSuffix
        )
    }

    /**
     Uses the supplied formatter and value to create a human-friendly string. The suffix will be `singularValueSuffix`
     if `value` is 1, or `pluralValueSuffix` otherwise

     - parameter value: The value to be formatted
     - parameter formatter: The formatter to use to format the numeric value
     - returns: The formatted string
     */
    public func formattedString(
        for value: NSNumber,
        usingFormatter formatter: NumberFormatter,
        singularValueSuffix: String,
        pluralValueSuffix: String
    ) -> String {
        let defaultValue = String(describing: value)

        let formattedValue = formatter.string(from: value) ?? defaultValue

        switch formatter.numberStyle {
        case .none, .decimal:
            let suffix = value == 1 ? singularValueSuffix : pluralValueSuffix
            return formattedValue + suffix
        default:
            return formattedValue
        }
    }

}
