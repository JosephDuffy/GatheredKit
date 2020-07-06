import Combine

/// An object that be started and stopped
public protocol Controllable: class {

    /// A boolean indicating if the `Controllable` is currently performing automatic updates
    var isUpdating: Bool { get }

    /// An update publisher that can be used to subscribe to events emitted by he controllable.
    var controllableEventUpdatePublisher: AnyUpdatePublisher<ControllableEvent> { get }

    /**
     Starts automatic updates. Closures added via `addUpdateListener(_:)` will be
     called when new properties are available
     */
    func startUpdating()

    /**
     Stops automatic updates
     */
    func stopUpdating()

}
