import Combine

public protocol ControllableSourceProvider: SourceProvider, AnyControllableSourceProvider {
    var sourceProviderEventsPublisher: AnyUpdatePublisher<SourceProviderEvent<ProvidedSource>> {
        get
    }
}

extension ControllableSourceProvider {
    public var typeErasedSourceProviderEventsPublisher: AnyUpdatePublisher<AnySourceProviderEvent> {
        return sourceProviderEventsPublisher.map { event -> AnySourceProviderEvent in
            switch event {
            case .sourceAdded(let source):
                return .sourceAdded(source)
            case .sourceRemoved(let source):
                return .sourceRemoved(source)
            }
        }.eraseToAnyUpdatePublisher()
    }
}
