
/**
 An error thrown by a `Unit`
 */
public enum UnitError: Error {

    /// Thrown when the supplied value's type is not supported
    case unsupportedType(type: Any.Type)

}
