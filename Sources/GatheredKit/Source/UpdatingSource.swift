#if canImport(Combine)
import Combine
#endif

public protocol UpdatingSource: Source {
    /// An update publisher that can be used to subscribe to events emitted by
    /// the source.
    var sourceEventPublisher: AnyUpdatePublisher<SourceEvent> { get }

    /// An `AsyncStream` of events emitted by this ``UpdatingSource``.
    var sourceEvents: AsyncStream<SourceEvent> { get }

    /// A boolean indicating if the source is currently performing automatic updates.
    var isUpdating: Bool { get }
}

extension UpdatingSource {
    public var sourceEvents: AsyncStream<SourceEvent> {
        AsyncStream<SourceEvent> { continuation in
            let cancellable = self.sourceEventPublisher.addUpdateListener { event in
                continuation.yield(event)
            }
            continuation.onTermination = { @Sendable [cancellable] _ in
                cancellable.cancel()
            }
        }
    }

    public var publisher: AnyPublisher<SourceEvent, Never> {
        sourceEventPublisher.combinePublisher
    }

    public func addUpdateListener(_ updateListener: @escaping AnyUpdatePublisher<SourceEvent>.UpdateListener) -> Subscription {
        sourceEventPublisher.addUpdateListener(updateListener)
    }
}
