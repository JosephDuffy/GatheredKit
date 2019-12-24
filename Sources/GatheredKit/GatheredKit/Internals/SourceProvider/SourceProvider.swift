public protocol SourceProvider: AnySourceProvider {

    associatedtype ProvidedSource: Source
    
    var sources: [ProvidedSource] { get }

}

extension SourceProvider {
    public var typeErasedSources: [Source] {
        return sources
    }
}
