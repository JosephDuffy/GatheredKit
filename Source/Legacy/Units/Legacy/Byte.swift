/**
 A struct that represents computer bytes
 */
public struct Byte: Unit {

    public enum CodingKeys: CodingKey {
        case countStyle
    }

    /// How the bytes should be styled
    public let countStyle: ByteCountFormatter.CountStyle

    /**
     Create a new `Byte` instance with a `file` `countStyle`

     - parameter countStyle: How the bytes should be styled. It is recommended that the `files` or `memory` style is used
     */
    public init() {
        self.init(countStyle: .file)
    }

    /**
     Create a new `Byte` instance

     - parameter countStyle: How the bytes should be styled. It is recommended that the `file` or `memory` style is used
     */
    public init(countStyle: ByteCountFormatter.CountStyle) {
        self.countStyle = countStyle
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawCountStyle = try container.decode(Int.self, forKey: .countStyle)
        guard let countStyle = ByteCountFormatter.CountStyle(rawValue: rawCountStyle) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [CodingKeys.countStyle], debugDescription: "Unknown count style \(rawCountStyle)"))
        }
        self.countStyle = countStyle
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(countStyle.rawValue, forKey: .countStyle)
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
