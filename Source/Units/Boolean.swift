
/**
 A struct that represents a value that can be either true or false
 */
public struct Boolean: SourcePropertyUnit {

    /// The string that will be returned from `formattedString(for:)` when the value is `true`. If `nil`, "true" will be returned
    public let trueString: String?

    /// The string that will be returned from `formattedString(for:)` when the value is `false`. If `nil`, "false" will be returned
    public let falseString: String?

    /**
     Create a new `Boolean` instance

     - parameter trueString: The string to return from `formattedString(for:)` when the value is `true`. If `nil`, "true" will be used
     - parameter falseString: The string to return from `formattedString(for:)` when the value is `false`. If `nil`, "false" will be used
     */
    public init(trueString: String?, falseString: String?) {
        self.trueString = trueString
        self.falseString = falseString
    }

    /**
     Generates a human-friendly string for the given boolean
     - parameter value: The boolean to be formatted
     - throws: `SourcePropertyUnitError.unsupportedType` if the `value` parameter's type is not a `Bool`
     - returns: The formatted string
     */
    public func formattedString(for value: Any) throws -> String {
        guard let boolValue = value as? Bool else {
            throw SourcePropertyUnitError.unsupportedType(type: type(of: value))
        }

        if boolValue, let trueString = trueString {
            return trueString
        } else if !boolValue, let falseString = falseString {
            return falseString
        } else {
            switch boolValue {
            case true:
                return "true"
            case false:
                return "false"
            }
        }
    }

}
