
/**
 An error thrown by a `SourcePropertyUnit`
 */
public enum SourcePropertyUnitError: Error {

    /// Thrown when the supplied value's type is not supported.
    case unsupportedType(type: Any.Type)

}
