/**
 An object that provides properties
 */
public protocol PropertiesProvider: class {

    /// An array of all the properties provided by this object
    var allProperties: [AnyProperty] { get }

}
