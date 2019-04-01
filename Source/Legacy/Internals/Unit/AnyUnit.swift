/**
 A unit of measurement for an instance of `Value`
 */
public protocol AnyUnit: Codable {

    init()

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

public protocol AnyUnitt: Unit where ValueType == Any {}

/**
 A unit of measurement for an instance of `Value`
 */
public protocol Unit: AnyUnit {

    associatedtype ValueType

    /**
     Generates a human-friendly string for the given value.

     Note: The implementation may choose to throw any arbitrary `Error`, but see
     `SourcePropertyUnitError` for common errors

     - parameter value: The value to be formatted

     - throws: `SourcePropertyUnitError.unsupportedType` if the `value` parameter's type is not supported
     - throws: Any arbitrary `Error` the implementor decides

     - returns: The formatted string
     */
    func formattedString(for value: ValueType) -> String

}

public extension Unit {

    func formattedString(for value: Any) throws -> String {
        guard let castValue = value as? ValueType else {
            throw UnitError.unsupportedType(type: type(of: value))
        }
        return formattedString(for: castValue)
    }

}
