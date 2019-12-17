import Foundation

public protocol Snapshot: AnySnapshot {
    associatedtype Value
    var value: Value { get }
}

extension Snapshot {

    public var typeErasedValue: Any? {
        switch value as Any {
        case Optional<Any>.some(let unwrapped):
            return unwrapped
        case Optional<Any>.none:
            return nil
        default:
            return value
        }
    }

}
