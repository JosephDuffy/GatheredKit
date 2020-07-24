import Foundation

public protocol AnySnapshot {
    var date: Date { get }
    var typeErasedValue: Any? { get }
}
