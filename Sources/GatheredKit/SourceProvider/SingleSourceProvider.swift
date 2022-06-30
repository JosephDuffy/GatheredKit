/// A source provider that contains a single source
public final class SingleSourceProvider<Source: GatheredKit.Source>: SourceProvider {
    public var name: String {
        source.name
    }

    public var sources: [Source] {
        [source]
    }

    public let source: Source

    public init(source: Source) {
        self.source = source
    }
}

public protocol SingleTransientSourceProvider: SourceProvider {
    var source: ProvidedSource? { get }
}

extension SingleTransientSourceProvider {
    public var sources: [ProvidedSource] {
        source.map { [$0] } ?? []
    }
}

public protocol ManuallyUpdatableSingleTransientSourceProvider: SingleTransientSourceProvider {
    @discardableResult
    func updateSource() async throws -> ProvidedSource?
}

extension ManuallyUpdatableSingleTransientSourceProvider {
    public func updateSource() async throws {
        _ = try await updateSource()
    }
}
