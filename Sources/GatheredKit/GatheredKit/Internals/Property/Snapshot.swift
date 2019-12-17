import Foundation

public protocol Snapshot: AnySnapshot {
    associatedtype Value
    var value: Value { get }
}

extension Snapshot {

    public var typeErasedValue: Any? {
        return castToOptional(value)
    }

}
