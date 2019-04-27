import Foundation

public final class CPU: BasePollingSource, Source, CustomisableUpdateIntervalControllable, ManuallyUpdatablePropertiesProvider {

    public static var defaultUpdateInterval: TimeInterval = 1

    public static let availability: SourceAvailability = .available

    public static let name = "CPU"

    public let numberOfCores: GenericUnitlessProperty<Int>
    public private(set) var activeCoreCount: GenericUnitlessProperty<Int>

    public var allProperties: [AnyProperty] {
        return [numberOfCores, activeCoreCount]
    }

    private let processInfo: ProcessInfo = .processInfo

    public override init() {
        numberOfCores = GenericUnitlessValue(
            displayName: "Number of Cores",
            value: processInfo.processorCount
        )
        activeCoreCount = GenericUnitlessValue(
            displayName: "Active Core Count",
            value: processInfo.activeProcessorCount
        )
    }

    public func updateValues() -> [AnyProperty] {
        activeCoreCount.update(value: processInfo.activeProcessorCount)

        return allProperties
    }

    private func hostCPULoadInfo() -> host_cpu_load_info? {
        let  HOST_CPU_LOAD_INFO_COUNT = MemoryLayout<host_cpu_load_info>.stride / MemoryLayout<integer_t>.stride

        var size = mach_msg_type_number_t(HOST_CPU_LOAD_INFO_COUNT)
        let hostInfo = host_cpu_load_info_t.allocate(capacity: 1)

        let result = hostInfo.withMemoryRebound(to: integer_t.self, capacity: HOST_CPU_LOAD_INFO_COUNT) {
            host_statistics(mach_host_self(), HOST_CPU_LOAD_INFO, $0, &size)
        }

        if result != KERN_SUCCESS{
            print("Error  - \(#file): \(#function) - kern_result_t = \(result)")
            return nil
        }
        let data = hostInfo.move()
        hostInfo.deallocate()
        return data
    }

}
