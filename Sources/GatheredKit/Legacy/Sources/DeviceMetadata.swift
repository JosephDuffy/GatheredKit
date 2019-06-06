import UIKit

public final class DeviceMetadata: BaseSource, Source, Controllable, ManuallyUpdatablePropertiesProvider {

    public struct Model: PropertiesProvider {

        public let allProperties: [AnyProperty]

        /// e.g. 'iPhone', 'Watch'
        public let platform: GenericUnitlessProperty<String?>

        /// The "iPhoneY,X" style identifier
        public let identifier: GenericUnitlessProperty<String>

        public init(platform: String, identifier: String) {
            self.platform = GenericUnitlessValue(displayName: "Platform", value: platform)
            self.identifier = GenericUnitlessValue(displayName: "Identifier", value: identifier)
            allProperties = [
                self.platform,
                self.identifier,
            ]
        }

        public init(device: UIDevice) {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }

            self.init(platform: device.model, identifier: identifier)
        }

    }

    private enum State {
        case notMonitoring
        case monitoring(nameObservation: NSKeyValueObservation, systemUptimeObservation: NSKeyValueObservation)
    }

    public static var availability: SourceAvailability = .available

    public static var name = "Device Metadata"

    /// A boolean indicating if the screen is monitoring for brightness changes
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public var name: GenericUnitlessProperty<String>
    public var model: GenericUnitlessProperty<Model?>
    public var systemUptime: GenericUnitlessProperty<TimeInterval>

    public var allProperties: [AnyProperty] {
        return [
            name,
            model,
        ]
    }

    private let device: UIDevice = .current

    private var state: State = .notMonitoring

    public override init() {
        name = GenericUnitlessValue(displayName: "Name", value: device.name)
        model = GenericUnitlessValue(displayName: "Model")
        systemUptime = GenericUnitlessValue(displayName: "System Uptime", value: ProcessInfo.processInfo.systemUptime)
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating() {
        defer {
            updateValues()
        }

        let nameObservation = device.observe(\.name, options: [.new]) { [weak self] device, change in
            guard let `self` = self else { return }
            self.name.update(value: device.name)
            self.notifyListenersPropertyValuesUpdated()
        }

        let systemUptimeObservation = ProcessInfo.processInfo.observe(\.systemUptime, options: [.new]) { [weak self] processInfo, change in
            guard let `self` = self else { return }
            self.systemUptime.update(value: processInfo.systemUptime)
            self.notifyListenersPropertyValuesUpdated()
        }

        state = .monitoring(nameObservation: nameObservation, systemUptimeObservation: systemUptimeObservation)
    }

    public func stopUpdating() {
        state = .notMonitoring
    }

    @discardableResult
    public func updateValues() -> [AnyProperty] {
        defer {
            notifyListenersPropertyValuesUpdated()
        }

        name.update(value: device.name)

        let model = Model(device: device)
        self.model.update(value: model)

        return allProperties
    }

}
