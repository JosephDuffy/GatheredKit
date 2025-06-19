import Combine

@MainActor
public protocol UpdatesProviding: AnyObject {
    /// A boolean indicating if the source is currently performing automatic updates.
    var isUpdating: Bool { get }

    var isUpdatingPublisher: AnyPublisher<Bool, Never> { get }
}

public protocol UpdatingSource: Source, UpdatesProviding {
    /// A Combine publisher that publishes events as they occur.
    var eventsPublisher: AnyPublisher<SourceEvent, Never> { get }
}
