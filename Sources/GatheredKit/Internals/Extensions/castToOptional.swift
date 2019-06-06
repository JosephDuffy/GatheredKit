/**
 Casts the provided value to `Any?`
 
 This method is required because casting an `Any` to `Any?` wraps the original `Any`
 in an `Optional`, producing an `Any??`.
 
 To get around this issue if the value passed is actually optional it is matched against
 the `Optional` case `some`, and the wrapped value is returned, wrapped in an `Optional`, allowing
 the compiler to correctly treat it as an `Any?`.
 
 If the passed value is not an `Optional` it is wrapped in an `Optional` for concistency.
 
 - parameter value: The value to be cast to `Any?`
 - returns: The provided value cast to `Any?`
 */
internal func castToOptional(_ value: Any) -> Any? {
    switch value {
    case Optional<Any>.some(let value):
        return Optional(value)
    case Optional<Any>.none:
        return nil
    default:
        return Optional(value)
    }
}
