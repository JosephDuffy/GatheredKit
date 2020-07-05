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
    /// An events publisher that will publish source provider events.
    /// - Important: This publisher will never publish any events; no sources will ever be added or removed from this provider.
    ///     A new instance is returned every time this property is accessed.
    public var sourceProviderEventsPublisher: AnyUpdatePublisher<SourceProviderEvent<Source>> {
        let subject = UpdateSubject<SourceProviderEvent<Source>>()
        return subject.eraseToAnyUpdatePublisher()
    }

    public var controllableEventUpdatePublisher: AnyUpdatePublisher<ControllableEvent> {
        source.controllableEventUpdatePublisher
    }

    public var isUpdating: Bool {
        return source.isUpdating
    }

    public func startUpdating() {
        source.startUpdating()
    }

    public func stopUpdating() {
        source.stopUpdating()
    }

}
