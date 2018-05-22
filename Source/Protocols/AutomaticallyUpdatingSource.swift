
/**
 A source that monitors its properties in real-time
 */
public protocol AutomaticallyUpdatingSource: Source {

    /// A boolean indicating if the source is currently performing automatic updated
    var isUpdating: Bool { get }

    /**
     Start monitoring for changes. Callback closures to be called when a property is updated
     */
    func startUpdating()

    /**
     Stop automatically updating
     */
    func stopUpdating()

}

extension AutomaticallyUpdatingSource {

    func startUpdating(_ updateListener: @escaping UpdateListener) -> AnyObject {
        let listenerToken = addUpdateListener(updateListener)
        startUpdating()
        return listenerToken
    }

}
