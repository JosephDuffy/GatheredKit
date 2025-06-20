/// An object that provides properties.
@MainActor
public protocol PropertiesProviding: AnyObject {
    /// An array of all the properties provided by this object
    var allProperties: [any Property] { get }
}
