import Combine

public protocol AutomaticUpdatingSourceProvider: UpdatingSourceProvider {
    var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<ProvidedSource>, Never> { get }
}

public protocol UpdatingSourceProvider: SourceProvider {
    var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<ProvidedSource>, Never> { get }
}
