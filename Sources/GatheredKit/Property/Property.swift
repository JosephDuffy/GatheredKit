import Combine
import Foundation

public protocol Property: AnyProperty {
    associatedtype Value
    associatedtype Formatter: Foundation.Formatter

    var snapshot: Snapshot<Value> { get }
    var value: Value { get }
    var formatter: Formatter { get }
    /// An asynchronous stream of snapshots, starting with the current snapshot.
    var snapshots: AsyncStream<Snapshot<Value>> { get }

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

    public var snapshots: AsyncStream<Snapshot<Value>> {
        AsyncStream<Snapshot<Value>> { continuation in
            let cancellable = snapshotsPublisher.sink { snapshot in
                continuation.yield(snapshot)
            }
            continuation.onTermination = { @Sendable [cancellable] _ in
                cancellable.cancel()
            }
        }
    }

    /// An asynchronous stream of values, starting with the current value.
    public var values: AsyncStream<Value> {
        AsyncStream<Value> { continuation in
            let cancellable = snapshotsPublisher.sink { snapshot in
                continuation.yield(snapshot.value)
            }
            continuation.onTermination = { @Sendable [cancellable] _ in
                cancellable.cancel()
            }
        }
    }

    /// A Combine publisher, starting with the current value.
    var valuePublisher: AnyPublisher<Value, Never> {
        snapshotsPublisher.map(\.value).eraseToAnyPublisher()
    }

    /// The type-erased current value of the property.
    public var typeErasedValue: Any? {
        snapshot.value
    }

    /// A type-erased formatter that can be used to build a human-friendly
    /// string from the value.
    public var typeErasedFormatter: Foundation.Formatter {
        formatter
    }

    public var typeErasedSnapshotPublisher: AnyPublisher<AnySnapshot, Never> {
        snapshotsPublisher.map { $0 as AnySnapshot }.eraseToAnyPublisher()
    }
}
