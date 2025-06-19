import Combine
import Foundation

@MainActor
public protocol Property<Value>: AnyObject {
    associatedtype Value

    var id: PropertyIdentifier { get }
    var error: Error? { get }
    var errorsPublisher: AnyPublisher<Error?, Never> { get }
    var snapshot: Snapshot<Value> { get }
    var value: Value { get }
    /// A Combine publisher, starting with the current snapshot.
    var snapshotsPublisher: AnyPublisher<Snapshot<Value>, Never> { get }
}

extension Property {
    public var value: Value {
        snapshot.value
    }

    /// The date of the latest value.
    public var date: Date {
        snapshot.date
    }

    public var error: Error? {
        nil
    }

    public var errorsPublisher: AnyPublisher<Error?, Never> {
        Just(nil).eraseToAnyPublisher()
    }

    /// A Combine publisher, starting with the current value.
    var valuePublisher: AnyPublisher<Value, Never> {
        snapshotsPublisher.map(\.value).eraseToAnyPublisher()
    }
}
