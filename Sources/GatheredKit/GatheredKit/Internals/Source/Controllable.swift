import Foundation
import Combine

/**
 An object that be started and stopped
 */
public protocol Controllable {

    associatedtype Publisher = Combine.Publisher

    var publisher: Publisher { get }

    /// A boolean indicating if the `Controllable` is currently performing automatic updates
    var isUpdating: Bool { get }

    /**
     Starts automatic updates. Closures added via `addUpdateListener(_:)` will be
     called when new properties are available
     */
    func startUpdating()

    /**
     Stops automatic updates
     */
    func stopUpdating()

}
