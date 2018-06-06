
/**
 An error thrown by a `SourcePropertyUnit`
 */
public enum UnitError: Error {

    /// Thrown when the supplied value's type is not supported.
    case unsupportedType(type: Any.Type)

}
