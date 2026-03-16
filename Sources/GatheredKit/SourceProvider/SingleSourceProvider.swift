/// A source provider that contains a single source
public final class SingleSourceProvider<Source: GatheredKit.Source>: SourceProvider {
    public var id: SourceProviderIdentifier {
        SourceProviderIdentifier(namespace: source.id.namespace, sourceKind: source.id.sourceKind)
    }

    public var sources: [Source] {
        [source]
    }

    public let source: Source

    public init(source: Source) {
        self.source = source
    }
}

public protocol SingleEphemeralSourceProvider: SourceProvider {
    var source: ProvidedSource? { get }
}

extension SingleEphemeralSourceProvider {
    public var sources: [ProvidedSource] {
        source.map { [$0] } ?? []
    }
}

public protocol ManuallyUpdatableSingleEphemeralSourceProvider: SingleEphemeralSourceProvider {
    @discardableResult
    func updateSource() async throws -> ProvidedSource?
}

extension ManuallyUpdatableSingleEphemeralSourceProvider {
    public func updateSource() async throws {
        _ = try await updateSource()
    }
}
