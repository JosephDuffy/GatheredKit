
/**
 A source that supports updating its properties at a given time interval
 */
public protocol CustomisableUpdateIntervalSource: Source {

    /// The time interval between property updates. A value of `nil` indicates that
    /// the source is not performing periodic updates
    var updateInterval: TimeInterval? { get }

    /// A boolean indicating if the source is performing period updates every `updateInterval`
    var isUpdating: Bool { get }

    /**
     Start performing periodic updates, updating every `updateInterval` seconds

     - parameter updateInterval: The interval between updates, measured in seconds
     */
    func startUpdating(every updateInterval: TimeInterval)

    /**
     Stop performing periodic updates
     */
    func stopUpdating()

}

public extension CustomisableUpdateIntervalSource {

    /// A boolean indicating if the source is currently updating its properties every `updateInterval`
    public var isUpdating: Bool {
        return updateInterval != nil
    }

    public func startUpdating(every updateInterval: TimeInterval, updateListener: @escaping UpdateListener) -> AnyObject {
        let listenerToken = addUpdateListener(updateListener)
        startUpdating(every: updateInterval)
        return listenerToken
    }

}
