import Foundation

public final class Memory:
        BasePollingSource, Source, ManuallyUpdatableValuesProvider
     {

    public static let availability: SourceAvailability = .available

    public static let name = "Memory"

    public private(set) var total: GenericValue<UInt64, Byte>
    public private(set) var free: GenericValue<UInt32?, Byte>
    public private(set) var used: GenericValue<UInt32?, Byte>
    public private(set) var active: GenericValue<UInt32?, Byte>
    public private(set) var inactive: GenericValue<UInt32?, Byte>
    public private(set) var wired: GenericValue<UInt32?, Byte>
    public private(set) var purgeable: GenericValue<UInt32?, Byte>

    public var allValues: [Value] {
        return [total, free, used, active, inactive, wired, purgeable]
    }

    public override init() {
        total = GenericValue(
            displayName: "Total",
            backingValue: ProcessInfo.processInfo.physicalMemory,
            unit: Byte(countStyle: .memory)
        )
        free = GenericValue(
            displayName: "Free",
            unit: Byte(countStyle: .memory)
        )
        used = GenericValue(
            displayName: "Used",
            unit: Byte(countStyle: .memory)
        )
        active = GenericValue(
            displayName: "Active",
            unit: Byte(countStyle: .memory)
        )
        inactive = GenericValue(
            displayName: "Inactive",
            unit: Byte(countStyle: .memory)
        )
        wired = GenericValue(
            displayName: "Wired",
            unit: Byte(countStyle: .memory)
        )
        purgeable = GenericValue(
            displayName: "Purgeable",
            unit: Byte(countStyle: .memory)
        )

        super.init()

        updateValues()
    }

    @discardableResult
    public  func updateValues() -> [Value] {
        total.update(backingValue: ProcessInfo.processInfo.physicalMemory)

        if let stats = vmStatistics() {
            let pageSize = UInt32(vm_page_size)

            free.update(backingValue: pageSize * stats.free_count)
            used.update(
                backingValue: pageSize
                    * (stats.active_count
                        + stats.inactive_count
                        + stats.wire_count)
            )
            active.update(backingValue: pageSize * stats.active_count)
            inactive.update(backingValue: pageSize * stats.inactive_count)
            wired.update(backingValue: pageSize * stats.wire_count)
            purgeable.update(backingValue: pageSize * stats.purgeable_count)
        } else {
            free.update(backingValue: nil)
            used.update(backingValue: nil)
            active.update(backingValue: nil)
            inactive.update(backingValue: nil)
            wired.update(backingValue: nil)
            purgeable.update(backingValue: nil)
        }

        return allValues
    }

    private func vmStatistics() -> vm_statistics64? {
        var size = mach_msg_type_number_t(
            MemoryLayout<vm_statistics_data_t>.stride
                / MemoryLayout<integer_t>.stride
        )
        var hostInfo = vm_statistics64()

        let result = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO, $0, &size)
            }
        }

        guard result == 0 else { return nil }

        return hostInfo
    }

}
