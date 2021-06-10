/// An object that provides properties.
public protocol PropertiesProvider: AnyObject {
    /// An array of all the properties provided by this object
    var allProperties: [AnyProperty] { get }
}
