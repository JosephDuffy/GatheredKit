import Foundation

public protocol Snapshot: AnySnapshot {
    associatedtype Value
    var value: Value { get }

    init(value: Value, date: Date)
}

extension Snapshot {

    public var typeErasedValue: Any? {
        return castToOptional(value)
    }

}
