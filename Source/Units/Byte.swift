/**
 A struct that represents computer bytes
 */
public struct Byte: TypedUnit {

    /// How the bytes should be styled
    public let countStyle: ByteCountFormatter.CountStyle

    /**
     Create a new `Byte` instance

     - parameter countStyle: How the bytes should be styled. It is recommended that the `files` or `memory` style is used
     */
    public init(countStyle: ByteCountFormatter.CountStyle) {
        self.countStyle = countStyle
    }

    /**
     Generates a human-friendly string for the given number
     - parameter value: The number to be formatted
     - throws: `SourcePropertyUnitError.unsupportedType` if the `value` parameter's type is not an `NSNumber`
     - returns: The formatted string
     */
    public func formattedString(for value: Int64) -> String {
        return ByteCountFormatter.string(
            fromByteCount: value,
            countStyle: countStyle
        )
    }

}
