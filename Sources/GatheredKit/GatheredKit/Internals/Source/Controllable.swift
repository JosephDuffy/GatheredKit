import Foundation
import Combine

/**
 An object that be started and stopped
 */
public protocol Controllable: Source {

    typealias Publisher = PassthroughSubject<[AnyProperty], Never>

    /// A publisher that will send all properties when any property changes.
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

extension Controllable {

    internal func publishUpdateWhenAnyPropertyUpdates() -> [AnyCancellable] {
        return allProperties.map { property in
            property.typeErasedPublisher.sink { [weak self] _ in
                guard let self = self else { return }
                self.publisher.send(self.allProperties)
            }
        }
    }

}
