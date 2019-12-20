import Foundation
import Combine

public enum ControllableEvent {
    case propertyUpdated(property: AnyProperty, snapshot: AnySnapshot)
    case startedUpdating
    case stoppedUpdating
    case requestingPermission
}

/**
 An object that be started and stopped
 */
public protocol Controllable: Source {

    typealias Publisher = PassthroughSubject<ControllableEvent, Never>

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
            // Without this Swift throws a "Type of expression is ambiguous without more context" error
            let _property = property
            return property.typeErasedPublisher.sink { [weak self, weak _property] snapshot in
                guard let self = self else { return }
                guard let property = _property else { return }
                self.publisher.send(.propertyUpdated(property: property, snapshot: snapshot))
            }
        }
    }

}
