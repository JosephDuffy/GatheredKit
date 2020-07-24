public protocol UpdatingSource: Source {
    /// An update publisher that can be used to subscribe to events emitted by he controllable.
    var sourceEventPublisher: AnyUpdatePublisher<SourceEvent> { get }

    /// A boolean indicating if the source is currently performing automatic updates.
    var isUpdating: Bool { get }
}
