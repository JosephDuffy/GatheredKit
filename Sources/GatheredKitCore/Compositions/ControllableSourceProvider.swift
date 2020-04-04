import Combine

public protocol ControllableSourceProvider: SourceProvider, AnyControllableSourceProvider {
    var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<ProvidedSource>, Never> { get }
}

extension ControllableSourceProvider {
    public var typeErasedSourceProviderEventsPublisher: AnyPublisher<AnySourceProviderEvent, Never> {
        return sourceProviderEventsPublisher.map { event in
            switch event {
            case .sourceAdded(let source):
                return .sourceAdded(source)
            case .sourceRemoved(let source):
                return .sourceRemoved(source)
            }
        }.eraseToAnyPublisher()
    }
}

public enum AnySourceProviderEvent {
    case sourceAdded(Source)
    case sourceRemoved(Source)
}

public protocol AnyControllableSourceProvider: AnySourceProvider, Controllable {
    var typeErasedSourceProviderEventsPublisher: AnyPublisher<AnySourceProviderEvent, Never> { get }
}
