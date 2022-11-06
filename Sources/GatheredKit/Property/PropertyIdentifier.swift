public struct PropertyIdentifier: Codable, Hashable, LosslessStringConvertible, Sendable {
    public enum Parent: Codable, Hashable, Sendable {
        case source(SourceIdentifier)
        indirect case property(PropertyIdentifier)
    }

    /// The character used to separate parent and child separators.
    public static let identifierSeparator: Character = "/"

    /// The parent entity of this property.
    public let parent: Parent

    /// A unique identifier for this property, scoped within its parent.
    public let id: String

    public let description: String

    public init(parent: PropertyIdentifier.Parent, id: String) {
        self.parent = parent
        self.id = id

        var description = id
        var parent = parent

        descriptionBuilder: while true {
            switch parent {
            case .source(let sourceIdentifier):
                description = sourceIdentifier.description
                    + String(Self.identifierSeparator)
                    + description
                break descriptionBuilder
            case .property(let propertyIdentifier):
                parent = propertyIdentifier.parent
                description = propertyIdentifier.id
                    + String(Self.identifierSeparator)
                    + description
            }
        }

        self.description = description
    }

    public init?(_ description: String) {
        let split = description.split(separator: Self.identifierSeparator)
        guard split.count >= 2 else { return nil }
        guard let sourceIdentifier = SourceIdentifier(String(split[0])) else { return nil }
        let propertyIdentifier = PropertyIdentifier(parent: .source(sourceIdentifier), id: String(split[1]))
        self = split.dropFirst(2).reduce(into: propertyIdentifier) { partialResult, propertyIdentifierString in
            partialResult = PropertyIdentifier(parent: .property(partialResult), id: String(propertyIdentifierString))
        }
    }

    public func childIdentifierForPropertyId(_ id: String) -> PropertyIdentifier {
        PropertyIdentifier(parent: .property(self), id: id)
    }

    public func sourceIdentifier() -> SourceIdentifier {
        var current = self

        while true {
            switch current.parent {
            case .source(let identifier):
                return identifier
            case .property(let identifier):
                current = identifier
            }
        }
    }

    public func asList() -> (SourceIdentifier, [PropertyIdentifier]) {
        var list: [PropertyIdentifier] = []
        var current = self
        var sourceIdentifier: SourceIdentifier?

        while sourceIdentifier == nil {
            list.insert(current, at: 0)

            switch current.parent {
            case .source(let _sourceIdentifier):
                sourceIdentifier = _sourceIdentifier
            case .property(let path):
                current = path
            }
        }

        return (sourceIdentifier!, list)
    }

    public func lineage() -> PropertyLineage {
        var identifiers: [String] = []
        var current = self
        var sourceIdentifier: SourceIdentifier?

        while sourceIdentifier == nil {
            identifiers.insert(current.id, at: 0)

            switch current.parent {
            case .source(let _sourceIdentifier):
                sourceIdentifier = _sourceIdentifier
            case .property(let path):
                current = path
            }
        }

        return PropertyLineage(
            sourceIdentifier: sourceIdentifier!,
            propertyIdentifiers: identifiers
        )
    }
}

public struct PropertyLineage: Codable, Hashable, Sendable {
    public let sourceIdentifier: SourceIdentifier

    public let propertyIdentifiers: [String]
}
