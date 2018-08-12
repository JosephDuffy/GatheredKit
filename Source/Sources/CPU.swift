import Foundation

public final class CPU:
        BasePollingSource, Source, ManuallyUpdatableValuesProvider
     {

    public static let availability: SourceAvailability = .available

    public static let name = "CPU"

    public let numberOfCores: GenericUnitlessValue<Int>
    public private(set) var activeCoreCount: GenericUnitlessValue<Int>

    public var allValues: [Value] {
        return [numberOfCores, activeCoreCount]
    }

    private let processInfo: ProcessInfo = .processInfo

    public override init() {
        numberOfCores = GenericUnitlessValue(
            displayName: "Number of Cores",
            backingValue: processInfo.processorCount
        )
        activeCoreCount = GenericUnitlessValue(
            displayName: "Active Core Count",
            backingValue: processInfo.activeProcessorCount
        )
    }

    public func updateValues() -> [Value] {
        activeCoreCount.update(backingValue: processInfo.activeProcessorCount)

        return allValues
    }

}
