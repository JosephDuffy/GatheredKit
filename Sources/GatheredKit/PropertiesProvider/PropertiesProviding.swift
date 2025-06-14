/// An object that provides properties.
public protocol PropertiesProviding: AnyObject, Sendable {
    /// An array of all the properties provided by this object
    var allProperties: [any Property] { get }
}
