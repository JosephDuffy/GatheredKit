import Combine

public protocol AutomaticUpdatingSourceProvider: UpdatingSourceProvider & AnyAutomaticUpdatingSourceProvider {
    var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<ProvidedSource>, Never> { get }
}

public protocol UpdatingSourceProvider: SourceProvider & AnyUpdatingSourceProvider {
    var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<ProvidedSource>, Never> { get }
}

extension UpdatingSourceProvider {
    public var typeErasedSourceProviderEventsPublisher: AnyPublisher<AnySourceProviderEvent, Never> {
        sourceProviderEventsPublisher.map { event in
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
        }.eraseToAnyPublisher()
    }
}
