import Combine

public final class SingleSourceProvider<Source: GatheredKitCore.Source>: SourceProvider {

    public var name: String {
        return source.name
    }

    public var sources: [Source] {
        return [source]
    }

    public let source: Source

    public init(source: Source) {
        self.source = source
    }

}

extension SingleSourceProvider: ControllableSourceProvider, Controllable, AnyControllableSourceProvider where Source: Controllable {

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<Source>, Never> {
        return Empty(completeImmediately: false, outputType: SourceProviderEvent<Source>.self, failureType: Never.self).eraseToAnyPublisher()
    }

    public var isUpdating: Bool {
        return source.isUpdating
    }

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return source.controllableEventsPublisher
    }

    public func startUpdating() {
        source.startUpdating()
    }

    public func stopUpdating() {
        source.stopUpdating()
    }

}
