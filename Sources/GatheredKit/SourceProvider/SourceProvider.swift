public protocol SourceProvider {
    /// The type of source this `SourceProvider` provides.
    associatedtype ProvidedSource: Source

    var id: SourceProviderIdentifier { get }

    var sources: [ProvidedSource] { get }
}
