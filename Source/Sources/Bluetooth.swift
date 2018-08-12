import CoreBluetooth

public final class Bluetooth: BaseSource, Source, Controllable {

    public enum Status: String {

        case unknown = "Unknown"

        case resetting = "Resetting"

        case unsupported = "Unsupported"

        case unauthorized = "Unauthorized"

        case off = "Off"

        case on = "On"

        fileprivate init(manager: CBCentralManager) {
            switch manager.state {
            case .unknown: self = .unknown
            case .resetting: self = .resetting
            case .unsupported: self = .unsupported
            case .unauthorized: self = .unauthorized
            case .poweredOff: self = .off
            case .poweredOn: self = .on
            }
        }

    }

    public static var availability: SourceAvailability {
        let manager = CBCentralManager(
            delegate: nil,
            queue: nil,
            options: [CBCentralManagerOptionShowPowerAlertKey: false]
        )
        return manager.state != .unsupported ? .available : .unavailable
    }

    public static let name = "Bluetooth"

    public var isUpdating: Bool {
        return manager.delegate != nil
    }

    public private(set) var status: GenericUnitlessValue<Status>

    public var allValues: [Value] {
        return [
            status,
        ]
    }

    private let manager: CBCentralManager

    public override init() {
        let queue = DispatchQueue(label: "")
        manager = CBCentralManager(
            delegate: nil,
            queue: queue,
            options: [CBCentralManagerOptionShowPowerAlertKey: false]
        )

        let status = Status(manager: manager)
        self.status = GenericUnitlessValue(displayName: "Status", backingValue: status, formattedValue: status.rawValue)
    }

    public func startUpdating() {
        manager.delegate = self
    }

    public func stopUpdating() {
        manager.delegate = nil
    }

}

extension Bluetooth: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let status = Status(manager: manager)
        self.status.update(backingValue: status, formattedValue: status.rawValue)
        notifyListenersPropertyValuesUpdated()
    }
}
