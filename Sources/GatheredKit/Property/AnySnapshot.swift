import Foundation

/// A type-erased snapshot of data.
public protocol AnySnapshot: Sendable {
    /// The point in time the data was captured.
    var date: Date { get }

    /// The data that was captured, erased as `Any`.
    var typeErasedValue: Any? { get }
}
