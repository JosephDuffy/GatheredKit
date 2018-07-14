import Foundation

/**
 A source that be started and stopped
 */
public protocol ControllableSource: Source {

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

public extension ControllableSource {

    /**
     Starts automatic updates and adds a closure to the array of closures that will be called when
     any of the source's values are updated. The closure will be called with all values, but
     not all the values will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter updateListener: The closure to call with updated values
     - parameter queue: The queue to send updates on
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    func startUpdating(sendingUpdatesTo updateListener: @escaping UpdateListener, on queue: DispatchQueue) -> AnyObject {
        let listenerToken = addUpdateListener(updateListener, queue: queue)
        startUpdating()
        return listenerToken
    }

}
