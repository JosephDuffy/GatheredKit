public protocol UpdatingSourceProvider: SourceProvider & AnyUpdatingSourceProvider {
    var sourceProviderEventsPublisher: AnyUpdatePublisher<SourceProviderEvent<ProvidedSource>> { get }
}

extension UpdatingSourceProvider {
    public var typeErasedSourceProviderEventsPublisher: AnyUpdatePublisher<AnySourceProviderEvent> {
        return sourceProviderEventsPublisher.map { event in
            switch event {
            case .startedUpdating:
                return .startedUpdating
            case .stoppedUpdating(let error):
                return .stoppedUpdating(error: error)
            case .sourceAdded(let source):
                return .sourceAdded(source)
            case .sourceRemoved(let source):
                return .sourceRemoved(source)
            }
        }.eraseToAnyUpdatePublisher()
    }
}
