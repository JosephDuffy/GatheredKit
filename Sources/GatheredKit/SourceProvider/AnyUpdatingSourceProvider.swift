public protocol AnyUpdatingSourceProvider: AnySourceProvider {
    var typeErasedSourceProviderEventsPublisher: AnyUpdatePublisher<AnySourceProviderEvent> { get }

    var isUpdating: Bool { get }
}
