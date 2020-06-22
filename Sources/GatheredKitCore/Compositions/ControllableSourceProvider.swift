import Combine

public protocol ControllableSourceProvider: SourceProvider, AnyControllableSourceProvider {
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<ProvidedSource>, Never> { get }
}

extension ControllableSourceProvider {
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
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
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    var typeErasedSourceProviderEventsPublisher: AnyPublisher<AnySourceProviderEvent, Never> { get }
}
