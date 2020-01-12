public protocol AnySourceProvider: class {
    
    var name: String { get }
    
    var typeErasedSources: [Source] { get }
    
}
