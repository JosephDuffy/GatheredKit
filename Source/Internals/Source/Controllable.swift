import Foundation

/**
 An object that be started and stopped
 */
public protocol Controllable: class {

    /// A boolean indicating if the `Controllable` is currently performing automatic updates
    var isUpdating: Bool { get }

    /**
     Starts automatic updates. Closures added via `addUpdateListener(_:)` will be
     called when new values are available
     */
    func startUpdating()

    /**
     Stops automatic updates
     */
    func stopUpdating()

}

public extension Controllable where Self: Source & UpdateConsumersProvider {

    /**
     Starts automatic updates and adds a closure to the array of closures that will be called when
     any of the source's values are updated. The closure will be called with all values, but
     not all the values will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter queue: The dispatch queue the listener should be called from. Defaults to `main`
     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    func startUpdating(
        sendingUpdatesOn queue: OperationQueue = .main,
        to updateListener: @escaping ClosureUpdatesConsumer.UpdatesClosure
    ) -> AnyObject {
        let listenerToken = addUpdateListener(updateListener, queue: queue)
        startUpdating()
        return listenerToken
    }

}
