import Foundation

public final class OperatingSystem: BasePollingSource, Source, Controllable, ManuallyUpdatableValuesProvider {

    public static let availability: SourceAvailability = .available

    public static let name = "Operating System"

    public let version: GenericUnitlessValue<OperatingSystemVersion>
    public let name: GenericUnitlessValue<String>
    public private(set) var uptime: GenericValue<TimeInterval, Time>

    public var allValues: [Value] {
        return [
            version,
            name,
            uptime,
        ]
    }

    private let device: UIDevice = .current
    private let processInfo: ProcessInfo = .processInfo

    public override init() {
        version = GenericUnitlessValue(
            displayName: "Version",
            backingValue: processInfo.operatingSystemVersion,
            formattedValue: processInfo.operatingSystemVersionString
        )
        name = GenericUnitlessValue(displayName: "Name", backingValue: device.systemName)
        uptime = GenericValue(displayName: "Uptime", backingValue: processInfo.systemUptime)
    }

    public func updateValues() -> [Value] {
        uptime.update(backingValue: processInfo.systemUptime)
        return allValues
    }

    public func startUpdating() {
        // TODO: Find a way to get this value every second, at the right time
        startUpdating(every: 0.5)
    }

}
