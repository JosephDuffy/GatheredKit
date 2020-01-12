public protocol AnySourceProvider: class {
    
    var name: String { get }
    
    var typeErasedSources: [(name: String, source: Source)] { get }
    
}
