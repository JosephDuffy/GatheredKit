public protocol SourceProvider: class {

    associatedtype ProvidedSource: Source
    
    var sources: [ProvidedSource] { get }

}
