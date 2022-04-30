import Combine

public protocol UpdatingSource: Source {
    /// An `AsyncStream` of events emitted by this ``UpdatingSource``.
    var events: AsyncStream<SourceEvent> { get }

    /// A Combine publisher that publishes events as they occur.
    var eventsPublisher: AnyPublisher<SourceEvent, Never> { get }

    /// A boolean indicating if the source is currently performing automatic updates.
    var isUpdating: Bool { get }
}

extension UpdatingSource {
    public var events: AsyncStream<SourceEvent> {
        AsyncStream<SourceEvent> { continuation in
            let cancellable = eventsPublisher.sink { event in
                continuation.yield(event)
            }
            continuation.onTermination = { @Sendable [cancellable] _ in
                cancellable.cancel()
            }
        }
    }
}
