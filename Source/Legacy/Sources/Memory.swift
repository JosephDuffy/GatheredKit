import Foundation

public final class Memory: BasePollingSource, Source, ManuallyUpdatablePropertiesProvider {

    public static let availability: SourceAvailability = .available

    public static let name = "Memory"

    public private(set) var total: GenericProperty<UInt64, Byte>
    public private(set) var free: GenericProperty<UInt32?, Byte>
    public private(set) var used: GenericProperty<UInt32?, Byte>
    public private(set) var active: GenericProperty<UInt32?, Byte>
    public private(set) var inactive: GenericProperty<UInt32?, Byte>
    public private(set) var wired: GenericProperty<UInt32?, Byte>
    public private(set) var purgeable: GenericProperty<UInt32?, Byte>

    public var allProperties: [AnyProperty] {
        return [total, free, used, active, inactive, wired, purgeable]
    }

    public override init() {
        total = GenericValue(
            displayName: "Total",
            value: ProcessInfo.processInfo.physicalMemory,
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
    public func updateValues() -> [AnyProperty] {
        total.update(value: ProcessInfo.processInfo.physicalMemory)

        if let stats = vmStatistics() {
            let pageSize = UInt32(vm_page_size)

            free.update(value: pageSize * stats.free_count)
            used.update(value: pageSize * (stats.active_count + stats.inactive_count + stats.wire_count))
            active.update(value: pageSize * stats.active_count)
            inactive.update(value: pageSize * stats.inactive_count)
            wired.update(value: pageSize * stats.wire_count)
            purgeable.update(value: pageSize * stats.purgeable_count)
        } else {
            free.update(value: nil)
            used.update(value: nil)
            active.update(value: nil)
            inactive.update(value: nil)
            wired.update(value: nil)
            purgeable.update(value: nil)
        }

        return allProperties
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
