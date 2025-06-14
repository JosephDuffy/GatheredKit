import Foundation
import GatheredKitSubscriptions

public protocol Property<Value, Error>: AnyObject {
    associatedtype Value
    associatedtype Error: Swift.Error

    /// A globally unique identifier.
    var id: PropertyIdentifier { get }

    /// The latest snapshot.
    var snapshot: Snapshot<Value> { get }

    /// The latest value.
    var value: Value { get }

    /// The date of the latest value.
    var date: Date { get }

    func makeSubscription() -> PropertySubscription<Snapshot<Value>, Error>
}

extension Property {
    public var value: Value {
        snapshot.value
    }

    public nonisolated var date: Date {
        snapshot.date
    }
}
