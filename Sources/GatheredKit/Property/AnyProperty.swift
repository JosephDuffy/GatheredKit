import Combine

public protocol AnyProperty: AnyObject, AnySnapshot {
    typealias AnyUpdateListener = (_ snapshot: AnySnapshot) -> Void

    var displayName: String { get }
    var error: Error? { get }
    var errorsPublisher: AnyPublisher<Error?, Never> { get }
    var typeErasedSnapshots: AsyncStream<AnySnapshot> { get }
    var typeErasedSnapshotPublisher: AnyPublisher<AnySnapshot, Never> { get }
}

extension AnyProperty {

    public var error: Error? {
        nil
    }

    public var errorsPublisher: AnyPublisher<Error?, Never> {
        Just(nil).eraseToAnyPublisher()
    }

    /// An asynchronous stream of values, starting with the current value.
    public var typeErasedSnapshots: AsyncStream<AnySnapshot> {
        AsyncStream<AnySnapshot> { continuation in
            let cancellable = typeErasedSnapshotPublisher.sink { snapshot in
                continuation.yield(snapshot)
            }
            continuation.onTermination = { @Sendable [cancellable] _ in
                cancellable.cancel()
            }
        }
    }
}
