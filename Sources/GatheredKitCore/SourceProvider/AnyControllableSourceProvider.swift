public protocol AnyControllableSourceProvider: AnySourceProvider, Controllable {
    var typeErasedSourceProviderEventsPublisher: AnyUpdatePublisher<AnySourceProviderEvent> { get }
}
