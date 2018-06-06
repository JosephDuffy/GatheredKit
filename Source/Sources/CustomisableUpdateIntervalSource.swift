
/**
 A source that supports updating its properties at a given time interval
 */
public protocol CustomisableUpdateIntervalSource: Source {

    /// The default update interval that will be used when calling `startUpdating()`
    /// without specifying the update interface
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

    public func startUpdating() {
        startUpdating(every: type(of: self).defaultUpdateInterval)
    }

    public func startUpdating(every updateInterval: TimeInterval, sendingUpdatesTo updateListener: @escaping UpdateListener) -> AnyObject {
        let listenerToken = addUpdateListener(updateListener)
        startUpdating(every: updateInterval)
        return listenerToken
    }

}
