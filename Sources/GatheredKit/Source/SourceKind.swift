public struct SourceKind: Codable, ExpressibleByStringLiteral, Hashable, LosslessStringConvertible, RawRepresentable, Sendable {
    public let kind: String

    public var rawValue: String {
        kind
    }

    public var description: String {
        kind
    }

    public init(stringLiteral value: String) {
        kind = value
    }

    public init(_ description: String) {
        kind = description
    }

    public init(rawValue: String) {
        kind = rawValue
    }
}
