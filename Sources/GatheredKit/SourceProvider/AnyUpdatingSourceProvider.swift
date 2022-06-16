import Combine

public protocol AnyAutomaticUpdatingSourceProvider: AnyUpdatingSourceProvider {
    var isUpdating: Bool { get }
}

public protocol AnyUpdatingSourceProvider: AnySourceProvider {
    var typeErasedSourceProviderEventsPublisher: AnyPublisher<AnySourceProviderEvent, Never> { get }
}
