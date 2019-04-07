/**
 An object that provides values
 */
public protocol ValuesProvider {

    /// An array of all the values provided by this object
    var allValues: [AnyValue] { get }

}
