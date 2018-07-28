import UIKit

public final class DeviceMetadata: BaseSource, Controllable, ManuallyUpdatableValuesProvider {

    public struct Model: ValuesProvider {

        public let allValues: [AnyValue]

        /// e.g. 'iPhone', 'Watch'
        public let platform: GenericValue<String?, None>

        /// The "iPhoneY,X" style identifier
        public let identifier: GenericValue<String, None>

        public init(platform: String, identifier: String) {
            self.platform = GenericValue(displayName: "Platform", backingValue: platform)
            self.identifier = GenericValue(displayName: "Identifier", backingValue: identifier)
            allValues = [
                self.platform.asAny(),
                self.identifier.asAny(),
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

    public static var displayName = "Device Metadata"

    /// A boolean indicating if the screen is monitoring for brightness changes
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public var name: GenericValue<String, None>
    public var model: GenericValue<Model?, None>
    public var systemUptime: GenericValue<TimeInterval, None>

    public var allValues: [AnyValue] {
        return [
            name.asAny(),
            model.asAny(),
        ]
    }

    private let device: UIDevice = .current

    private var state: State = .notMonitoring

    public override init() {
        name = GenericValue(displayName: "Name", backingValue: device.name)
        model = GenericValue(displayName: "Model")
        systemUptime = GenericValue(displayName: "System Uptime", backingValue: ProcessInfo.processInfo.systemUptime)
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
            self.name.update(backingValue: device.name)
            self.notifyListenersPropertyValuesUpdated()
        }

        let systemUptimeObservation = ProcessInfo.processInfo.observe(\.systemUptime, options: [.new]) { [weak self] processInfo, change in
            guard let `self` = self else { return }
            self.systemUptime.update(backingValue: processInfo.systemUptime)
            self.notifyListenersPropertyValuesUpdated()
        }

        state = .monitoring(nameObservation: nameObservation, systemUptimeObservation: systemUptimeObservation)
    }

    public func stopUpdating() {
        state = .notMonitoring
    }

    @discardableResult
    public func updateValues() -> [AnyValue] {
        defer {
            notifyListenersPropertyValuesUpdated()
        }

        name.update(backingValue: device.name)

        let model = Model(device: device)
        self.model.update(backingValue: model)

        return allValues
    }

}
