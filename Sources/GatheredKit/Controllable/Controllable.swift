import Combine

/// An object that can have the status of its updates controlled.
public protocol Controllable: UpdatesProviding {
    /// Start automatically updating all properties.
    func startUpdating() async

    /// Stop automatically updating all properties.
    func stopUpdating() async
}
