public protocol SourceProvider: AnySourceProvider {
    /// The type of source this `SourceProvider` provides.
    associatedtype ProvidedSource: Source

    var sources: [ProvidedSource] { get }
}

extension SourceProvider {
    public var typeErasedSources: [Source] {
        return sources
    }
}
