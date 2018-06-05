
/**
 A special unit that respresents no unit.
 */
public struct None: SourcePropertyUnit {

    /**
     Generates a human-friendly string for the given boolean
     - parameter value: The value to be formatted
     - throws: `SourcePropertyUnitError.unsupportedType` if the `value` parameter's type is not a `Bool`
     - returns: The formatted string
     */
    public func formattedString(for value: Any) throws -> String {
        return String(describing: value)
    }

}
