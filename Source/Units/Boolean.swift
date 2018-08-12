
/**
 A struct that represents a value that can be either true or false
 */
public struct Boolean: TypedUnit {

    /// The string that will be returned from `formattedString(for:)` when the value is `true`
    public let trueString: String

    /// The string that will be returned from `formattedString(for:)` when the value is `false`
    public let falseString: String

    /**
     Create a new `Boolean` instance

     - parameter trueString: The string to return from `formattedString(for:)` when the value is `true`. Defaults to "true"
     - parameter falseString: The string to return from `formattedString(for:)` when the value is `false`. Defaults to "false"
     */
    public init(trueString: String = "true", falseString: String = "false") {
        self.trueString = trueString
        self.falseString = falseString
    }

    /**
     Generates a human-friendly string for the given boolean
     - parameter value: The boolean to be formatted
     - returns: The formatted string
     */
    public func formattedString(for value: Bool) -> String {
        return value ? trueString : falseString
    }

    /**
     Generates a human-friendly string for the given boolean
     - parameter value: The boolean to be formatted
     - parameter trueString: A custom string to return when `value` is `true`
     - parameter flaseString: A custom string to return when `value` is `false`
     - returns: The formatted string
     */
    public func formattedString(for value: Bool, trueString: String, falseString: String) -> String {
        return value ? trueString : falseString
    }

}
