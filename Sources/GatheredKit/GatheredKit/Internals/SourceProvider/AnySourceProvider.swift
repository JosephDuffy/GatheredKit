public protocol AnySourceProvider: class {
    
    static var name: String { get }
    
    var typeErasedSources: [(name: String, source: Source)] { get }
    
}
