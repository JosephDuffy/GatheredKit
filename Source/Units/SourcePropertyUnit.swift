
/**
 A unit of measurement for an instance of `SourceProperty`
 */
public protocol SourcePropertyUnit {

    /**
     Generates a human-friendly string for the given value.

     Note: The implementation may choose to throw any arbitrary `Error`, but see
     `SourcePropertyUnitError` for common errors

     - parameter value: The value to be formatted

     - throws: `SourcePropertyUnitError.unsupportedType` if the `value` parameter's type is not supported
     - throws: Any arbitrary `Error` the implementor decides

     - returns: The formatted string
     */
    func formattedString(for value: Any) throws -> String

}
