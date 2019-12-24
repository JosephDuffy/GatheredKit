public protocol SourceProvider: AnySourceProvider {

    associatedtype ProvidedSource: Source
    
    var sources: [(name: String, source: ProvidedSource)] { get }

}

extension SourceProvider {
    public var typeErasedSources: [(name: String, source: Source)] {
        return sources
    }
}
