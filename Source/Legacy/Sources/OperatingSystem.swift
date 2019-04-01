import Foundation

public final class OperatingSystem: BasePollingSource, Source, CustomisableUpdateIntervalControllable, ManuallyUpdatableValuesProvider {

    public static var defaultUpdateInterval: TimeInterval = 0.5

    public static let availability: SourceAvailability = .available

    public static let name = "Operating System"

    public let version: GenericUnitlessValue<OperatingSystemVersion>
    public let build: GenericUnitlessValue<String?>
    public let name: GenericUnitlessValue<String>
    public private(set) var uptime: GenericValue<TimeInterval, Time>

    private var observer: NSObjectProtocol?

    public var allValues: [AnyValue] {
        return [
            version,
            build,
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

        let buildValue = try? SysctlHelper.string(for: [CTL_KERN, KERN_OSVERSION])
        let buildFormattedValue = buildValue == nil ? "Unknown" : nil

        build = GenericUnitlessValue(
            displayName: "Build",
            backingValue: buildValue,
            formattedValue: buildFormattedValue
        )
    }

    public func updateValues() -> [AnyValue] {
        uptime.update(backingValue: processInfo.systemUptime)
        return allValues
    }

    public func startUpdating() {
        // TODO: Find a way to get this value every second, at the right time
        startUpdating(every: 0.5)
    }

}

private struct SysctlHelper {

    enum Error: Swift.Error {

        /// A POSIX error
        case posixError(POSIXErrorCode)

        /// The returned data was not valid UTF8
        case invalidUTF8

        /// A call to `sysctl` resulted in an error, but the `errno`
        /// variable could not be mapped to a valid `POSIXErrorCode`
        case unknownPOSIXError(Int32)
    }

    static func string(for keys: [Int32]) throws -> String {
        let data = try self.data(for: keys)

        let stringValue = data.withUnsafeBufferPointer() { dataPointer in
            dataPointer.baseAddress.flatMap { String(validatingUTF8: $0) }
        }

        if let stringValue = stringValue {
            return stringValue
        } else {
            throw Error.invalidUTF8
        }
    }

    private static func data(for keys: [Int32]) throws -> [Int8] {
        return try keys.withUnsafeBufferPointer() { keysPointer throws -> [Int8] in
            var requiredSize = -1
            let requiredSizeCheckResult = sysctl(
                UnsafeMutablePointer<Int32>(mutating: keysPointer.baseAddress),
                UInt32(keys.count),
                nil,
                &requiredSize,
                nil,
                0
            )

            guard requiredSizeCheckResult == 0 else {
                try throwPOSIXError()
            }

            let data = [Int8](repeating: 0, count: requiredSize)
            let readResult = data.withUnsafeBufferPointer() { dataPointer in
                return sysctl(
                    UnsafeMutablePointer<Int32>(mutating: keysPointer.baseAddress),
                    UInt32(keys.count),
                    UnsafeMutableRawPointer(mutating: dataPointer.baseAddress),
                    &requiredSize,
                    nil,
                    0
                )
            }

            guard readResult == 0 else {
                try throwPOSIXError()
            }

            return data
        }
    }

    /**
     Throws an `Error.posixError`, if a `POSIXErrorCode` can be created
     from the `errno` global variable. If a `POSIXErrorCode` cannot be created
     `Error.unknown` is thrown
     */
    private static func throwPOSIXError() throws -> Never {
        if let posixError = POSIXErrorCode(rawValue: errno) {
            throw Error.posixError(posixError)
        } else {
            throw Error.unknownPOSIXError(errno)
        }
    }

}
