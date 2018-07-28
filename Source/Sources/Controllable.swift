import Foundation

/**
 An object that be started and stopped
 */
public protocol Controllable {

    /// A closure that will be called with the latest values
    typealias UpdateListener = (_ latestValues: [AnyValue]) -> Void

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

    /**
     Adds a closure to the array of closures that will be called when any of the source's
     values are updated. The closure will be called with all values, but not all the values
     will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter updateListener: The closure to call with updated values
     - parameter queue: The dispatch queue the listener should be called from
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    func addUpdateListener(_ updateListener: @escaping UpdateListener, queue: DispatchQueue) -> AnyObject

}

public extension Controllable {

    /**
     Starts automatic updates and adds a closure to the array of closures that will be called when
     any of the source's values are updated. The closure will be called with all values, but
     not all the values will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter queue: The dispatch queue the listener should be called from
     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    func startUpdating(sendingUpdatesOn queue: DispatchQueue, to updateListener: @escaping UpdateListener) -> AnyObject {
        let listenerToken = addUpdateListener(updateListener, queue: queue)
        startUpdating()
        return listenerToken
    }

    /**
     Starts automatic updates and adds a closure to the array of closures that will be called when
     any of the source's values are updated. The closure will be called on the main dispatch queue with
     all values, but not all the values will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    func startUpdating(sendingUpdatesTo updateListener: @escaping UpdateListener) -> AnyObject {
        let listenerToken = addUpdateListener(updateListener, queue: .main)
        startUpdating()
        return listenerToken
    }

}
