
/**
 An object that can provide data from a specific source on the device
 */
public protocol Source: class {

    typealias UpdateListener = (_ data: [AnySourceProperty]) -> Void

    static var availability: SourceAvailability { get }

    /// A boolean indicating if the source is currently performing automatic updates
    var isUpdating: Bool { get }

    var latestPropertyValues: [AnySourceProperty] { get }

    init()

    func addUpdateListener(_ updateListener: @escaping UpdateListener) -> AnyObject

    /**
     Start monitoring for changes. Callback closures to be called when a property is updated
     */
    func startUpdating()

    /**
     Stop automatically updating
     */
    func stopUpdating()
    
}

extension Source {

    func startUpdating(sendingUpdatesTo updateListener: @escaping UpdateListener) -> AnyObject {
        let listenerToken = addUpdateListener(updateListener)
        startUpdating()
        return listenerToken
    }

}
