import Foundation

/**
 A source that supports updating its properties at a given time interval
 */
public protocol CustomisableUpdateIntervalControllable: Controllable {

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

extension CustomisableUpdateIntervalControllable {

    /**
     Starts performing period updated. The value of the static variable `defaultUpdateInterval` will
     used for the update interval.
     */
    public func startUpdating() {
        startUpdating(every: type(of: self).defaultUpdateInterval)
    }

}
