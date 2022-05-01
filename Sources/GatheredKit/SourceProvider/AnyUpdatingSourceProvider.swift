import Combine

public protocol AnyUpdatingSourceProvider: AnySourceProvider {
    var typeErasedSourceProviderEventsPublisher: AnyPublisher<AnySourceProviderEvent, Never> { get }

    var isUpdating: Bool { get }
}
