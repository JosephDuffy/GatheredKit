import Foundation

/**
 An object that be started and stopped
 */
public protocol Controllable: class {

    /// A boolean indicating if the `Controllable` is currently performing automatic updates
    var isUpdating: Bool { get }

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

public extension Controllable where Self: Producer {

    /**
     Starts automatic updates and adds a closure to the array of closures that will be called when
     any of the producer's properties are updated. The closure will be called with all properties, but
     not all the properties will neccessary have new values.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed and no longer called.

     - parameter queue: The dispatch queue the listener should be called from. Defaults to `main`
     - parameter updateListener: The closure to call with the updated properties
     - returns: The create consuner. The lifecycle of the listener is tied to the object
     */
    func startUpdating(
        sendingUpdatesOn queue: OperationQueue = .main,
        to updateListener: @escaping ClosureConsumer<ProducedValue, Self>.UpdatesClosure
    ) -> ClosureConsumer<ProducedValue, Self> {
        let consumer = consumeUpdates(sendingUpdatesOn: queue, to: updateListener)
        startUpdating()
        return consumer
    }

}
