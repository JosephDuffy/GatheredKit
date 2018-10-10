/**
 A source that supports updating its properties at a given time interval
 */
public protocol CustomisableUpdateIntervalSource: Source {

    /// The default update interval that will be used when calling `startUpdating()`
    /// without specifying the update interval.
    /// This value is unique per-source and does not persist between app runs
    static var defaultUpdateInterval: TimeInterval { get set }

    /// The time interval between property updates. A value of `nil` indicates that
    /// the source is not performing periodic updates
    var updateInterval: TimeInterval? { get }

    /**
     Start performing periodic updates, updating every `updateInterval` seconds

     - parameter updateInterval: The interval between updates, measured in seconds
     */
    func startUpdating(every updateInterval: TimeInterval)

}

public extension CustomisableUpdateIntervalSource {

    /// A boolean indicating if the source is currently updating its properties every `updateInterval`
    public var isUpdating: Bool {
        return updateInterval != nil
    }

    /**
     Starts performing period updated. The value of the static variable `defaultUpdateInterval` will
     used for the update interval.
     */
    public func startUpdating() {
        startUpdating(every: type(of: self).defaultUpdateInterval)
    }

    /**
     Start performing periodic updates, updating every `updateInterval` seconds.

     The passed closure will be added to the array of closures that will be called when any
     of the source's values are updated. The closure will be called with all values, but not
     all the values will neccessary be new.

     The returned object must be retained; the lifecycle of the listener is tied to the object. If
     the object is deallocated the listener will be destroyed.

     - parameter updateInterval: The interval between updates, measured in seconds
     - parameter queue: The dispatch queue the listener should be called from
     - parameter updateListener: The closure to call with updated values
     - returns: An opaque object. The lifecycle of the listener is tied to the object
     */
    public func startUpdating(
        every updateInterval: TimeInterval,
        sendingUpdatesOn queue: DispatchQueue,
        to updateListener: @escaping Source.UpdateListener
    ) -> AnyObject {
        let listenerToken = addUpdateListener(updateListener, queue: queue)
        startUpdating(every: updateInterval)
        return listenerToken
    }

}
