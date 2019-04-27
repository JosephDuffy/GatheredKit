import Foundation

public protocol AnyProperty: AnyProducer {
    var displayName: String { get }
    var valueAsAny: Any? { get }
    var date: Date { get }
    var anyFormatter: Formatter { get }
    var formattedValue: String? { get }
}
