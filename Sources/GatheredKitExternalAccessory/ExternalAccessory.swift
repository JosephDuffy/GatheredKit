#if canImport(ExternalAccessory)
import Combine
import ExternalAccessory
import GatheredKit

public final class ExternalAccessory: UpdatingSource, Controllable {
    private enum State {
        case notMonitoring
        case monitoring(delegate: AccessoryDelegate)
    }

    public let availability: SourceAvailability = .available

    public let id: SourceIdentifier

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    @Published
    public private(set) var isUpdating: Bool = false

    public var isUpdatingPublisher: AnyPublisher<Bool, Never> {
        $isUpdating.eraseToAnyPublisher()
    }

    public let accessory: EAAccessory

    @BasicProperty
    public private(set) var isConnected: Bool

    @BasicProperty
    public private(set) var connectionID: Int

    @BasicProperty
    public private(set) var manufacturer: String

    @BasicProperty
    public private(set) var modelNumber: String

    @BasicProperty
    public private(set) var serialNumber: String

    @BasicProperty
    public private(set) var firmwareRevision: String

    @BasicProperty
    public private(set) var hardwareRevision: String

    public var allProperties: [any Property] {
        [
            $isConnected,
            $connectionID,
            $manufacturer,
            $modelNumber,
            $serialNumber,
            $firmwareRevision,
            $hardwareRevision,
        ]
    }

    private var state: State = .notMonitoring {
        didSet {
            switch state {
            case .monitoring:
                isUpdating = true
            case .notMonitoring:
                isUpdating = false
            }
        }
    }

    public init(accessory: EAAccessory) {
        self.accessory = accessory
        id = SourceIdentifier(
            sourceKind: .externalAccessory,
            instanceIdentifier: "\(accessory.connectionID)",
            isTransient: true
        )
        _isConnected = .init(
            id: id.identifierForChildPropertyWithId("connected"),
            value: accessory.isConnected
        )
        _connectionID = .init(
            id: id.identifierForChildPropertyWithId("connectionIdentifier"),
            value: accessory.connectionID
        )
        _manufacturer = .init(
            id: id.identifierForChildPropertyWithId("manufacturer"),
            value: accessory.manufacturer
        )
        _modelNumber = .init(
            id: id.identifierForChildPropertyWithId("modelNumber"),
            value: accessory.modelNumber
        )
        _serialNumber = .init(
            id: id.identifierForChildPropertyWithId("serialNumber"),
            value: accessory.serialNumber
        )
        _firmwareRevision = .init(
            id: id.identifierForChildPropertyWithId("firmwareRevision"),
            value: accessory.manufacturer
        )
        _hardwareRevision = .init(
            id: id.identifierForChildPropertyWithId("hardwareRevision"),
            value: accessory.hardwareRevision
        )
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        let delegate = AccessoryDelegate { [weak self] accessory in
            guard let self = self else { return }
            assert(self.accessory === accessory)
            if !self.isConnected {
                self._isConnected.updateValue(false)
            }
        }

        accessory.delegate = delegate

        eventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        state = .notMonitoring
        eventsSubject.send(.stoppedUpdating())
    }
}

private final class AccessoryDelegate: NSObject, EAAccessoryDelegate {
    typealias AccessoryDidDisconnectHandler = (_ accessory: EAAccessory) -> Void

    private let accessoryDidDisconnectHandler: AccessoryDidDisconnectHandler

    init(accessoryDidDisconnectHandler: @escaping AccessoryDidDisconnectHandler) {
        self.accessoryDidDisconnectHandler = accessoryDidDisconnectHandler
    }

    func accessoryDidDisconnect(_ accessory: EAAccessory) {
        accessoryDidDisconnectHandler(accessory)
    }
}
#endif
