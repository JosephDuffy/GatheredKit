#if canImport(Combine)
import Combine
#endif

public protocol UpdatingSource: Source {
    /// An update publisher that can be used to subscribe to events emitted by he controllable.
    var sourceEventPublisher: AnyUpdatePublisher<SourceEvent> { get }

    /// A boolean indicating if the source is currently performing automatic updates.
    var isUpdating: Bool { get }
}

extension UpdatingSource {
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public var publisher: AnyPublisher<SourceEvent, Never> {
        sourceEventPublisher.combinePublisher
    }

    public func addUpdateListener(_ updateListener: @escaping AnyUpdatePublisher<SourceEvent>.UpdateListener) -> Subscription {
        sourceEventPublisher.addUpdateListener(updateListener)
    }
}
