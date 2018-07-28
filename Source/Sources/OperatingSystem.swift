import Foundation

public final class OperatingSystem: BasePollingSource, Source, Controllable, ManuallyUpdatableValuesProvider {

    public static let availability: SourceAvailability = .available

    public let displayName = "Operating System"

    public let version: GenericValue<OperatingSystemVersion, None>
    public let name: GenericValue<String, None>
    public private(set) var uptime: GenericValue<TimeInterval, Time>

    public var allValues: [AnyValue] {
        return [
            version.asAny(),
            name.asAny(),
            uptime.asAny(),
        ]
    }

    private let device: UIDevice = .current
    private let processInfo: ProcessInfo = .processInfo

    public override init() {
        version = GenericValue(
            displayName: "Version",
            backingValue: processInfo.operatingSystemVersion,
            formattedValue: processInfo.operatingSystemVersionString
        )
        name = GenericValue(displayName: "Name", backingValue: device.systemName)
        uptime = GenericValue(displayName: "Uptime", backingValue: processInfo.systemUptime)
    }

    public func updateValues() -> [AnyValue] {
        uptime.update(backingValue: processInfo.systemUptime)
        return allValues
    }

    public func startUpdating() {
        startUpdating(every: 1)
    }

}
