import Foundation

// TODO: Rename to `AnyProperty`
public protocol AnyValue: AnyProducer {
    var displayName: String { get }
    var backingValueAsAny: Any? { get }
    var date: Date { get }
    var anyFormatter: Formatter { get }
    var formattedValue: String? { get }
}
