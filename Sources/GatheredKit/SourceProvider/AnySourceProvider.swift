public protocol AnySourceProvider: AnyObject {

    var name: String { get }

    var typeErasedSources: [Source] { get }

}
