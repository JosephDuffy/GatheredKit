#if canImport(ExternalAccessory)
import Combine
import ExternalAccessory
import GatheredKit

/// A wrapper around `UIScreen`.
public final class ExternalAccessory: UpdatingSource, Controllable {
    private enum State {
        case notMonitoring
        case monitoring(delegate: AccessoryDelegate)
    }

    public let availability: SourceAvailability = .available

    public let name: String

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

    @BoolProperty
    public private(set) var isConnected: Bool

    @IntProperty
    public private(set) var connectionID: Int

    @StringProperty
    public private(set) var manufacturer: String

    @StringProperty
    public private(set) var modelNumber: String

    @StringProperty
    public private(set) var serialNumber: String

    @StringProperty
    public private(set) var firmwareRevision: String

    @StringProperty
    public private(set) var hardwareRevision: String

    public var allProperties: [AnyProperty] {
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
        name = accessory.name
        _isConnected = .init(
            displayName: "Connected",
            value: accessory.isConnected,
            formatter: BoolFormatter(trueString: "Yes", falseString: "No")
        )
        _connectionID = .init(
            displayName: "Connection Identifier",
            value: accessory.connectionID
        )
        _manufacturer = .init(
            displayName: "Manufacturer",
            value: accessory.manufacturer
        )
        _modelNumber = .init(
            displayName: "Model Number",
            value: accessory.modelNumber
        )
        _serialNumber = .init(
            displayName: "Serial Number",
            value: accessory.serialNumber
        )
        _firmwareRevision = .init(
            displayName: "Firmware Revision",
            value: accessory.manufacturer
        )
        _hardwareRevision = .init(
            displayName: "Hardware Revision",
            value: accessory.hardwareRevision
        )
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        let delegate = AccessoryDelegate { [weak self] accessory in
            guard let self = self else { return }
            assert(self.accessory === accessory)
            if !self.isConnected {
                let snapshot = self._isConnected.updateValue(false)
                self.eventsSubject.send(.propertyUpdated(property: self._isConnected, snapshot: snapshot))
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
