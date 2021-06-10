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
