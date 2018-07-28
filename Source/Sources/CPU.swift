import Foundation

public final class CPU: BasePollingSource, Source, ManuallyUpdatableValuesProvider {

    public static let availability: SourceAvailability = .available

    public let displayName = "CPU"

    public let numberOfCores: GenericValue<Int, None>
    public private(set) var activeCoreCount: GenericValue<Int, None>

    public var allValues: [AnyValue] {
        return [
            numberOfCores.asAny(),
            activeCoreCount.asAny(),
        ]
    }

    private let processInfo: ProcessInfo = .processInfo

    public override init() {
        numberOfCores = GenericValue(displayName: "Number of Cores", backingValue: processInfo.processorCount)
        activeCoreCount = GenericValue(displayName: "Active Core Count", backingValue: processInfo.activeProcessorCount)
    }

    public func updateValues() -> [AnyValue] {
        activeCoreCount.update(backingValue: processInfo.activeProcessorCount)

        return allValues
    }

}
