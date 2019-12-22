import Combine

public protocol ControllableSource: Controllable & Source where Publisher == PassthroughSubject<ControllableSourceEvent, ControllableSourceError> {}

extension ControllableSource {

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
