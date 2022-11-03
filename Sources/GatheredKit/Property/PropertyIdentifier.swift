public struct PropertyIdentifier: Codable, Hashable, Sendable {
    public enum Parent: Codable, Hashable, Sendable {
        case source(SourceIdentifier)
        indirect case property(PropertyIdentifier)
    }

    /// The parent entity of this property.
    public let parent: Parent

    /// A unique identifier for this property, scoped within its parent.
    public let id: String

    public init(parent: PropertyIdentifier.Parent, id: String) {
        self.parent = parent
        self.id = id
    }

    public func childIdentifierForPropertyId(_ id: String) -> PropertyIdentifier {
        PropertyIdentifier(parent: .property(self), id: id)
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
