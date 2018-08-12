import Foundation

/**
 An object that provides values
 */
public protocol ValuesProvider {

    /// An array of all the values provided by this object
    var allValues: [Value] { get }

}

extension Optional: ValuesProvider where Wrapped: ValuesProvider {

    public var allValues: [Value] {
        return map { $0.allValues } ?? []
    }

}
