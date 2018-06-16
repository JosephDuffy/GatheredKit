
/**
 An object that can provide data from a specific source on the device
 */
public protocol Source: class, ValuesProvider {

    /// A closure that will be called with the latest values
    typealias UpdateListener = (_ latestValues: [AnyValue]) -> Void

    /// The availability of the source
    static var availability: SourceAvailability { get }

    /// A boolean indicating if the source is currently performing automatic updates
    var isUpdating: Bool { get }

    /// Creates a new instance of the source
    init()

    /**
     Adds a closure to the array of closures that will be called when any of the source's
     values are updated. The closure will be called with all values, but not all the values
     will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    func addUpdateListener(_ updateListener: @escaping UpdateListener) -> AnyObject

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

public extension Source {

    /**
     Starts automatic updates and adds a closure to the array of closures that will be called when
     any of the source's values are updated. The closure will be called with all values, but
     not all the values will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    func startUpdating(sendingUpdatesTo updateListener: @escaping UpdateListener) -> AnyObject {
        let listenerToken = addUpdateListener(updateListener)
        startUpdating()
        return listenerToken
    }

}
