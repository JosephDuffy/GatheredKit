import GatheredKit
import Foundation

public final class MemoryStatistics: Source, ManuallyUpdatablePropertiesProvider {
    public let availability: SourceAvailability = .available

    public let id: SourceIdentifier

    @MeasurementProperty
    public private(set) var total: Measurement<UnitInformationStorage>

    @BasicProperty
    public private(set) var freePages: UInt32?

    @BasicProperty
    public private(set) var activePages: UInt32?

    @BasicProperty
    public private(set) var inactivePages: UInt32?

    @BasicProperty
    public private(set) var wiredPages: UInt32?

    @BasicProperty
    public private(set) var zeroFillPages: UInt64?

    @BasicProperty
    public private(set) var reactivatedPages: UInt64?

    @BasicProperty
    public private(set) var pageIns: UInt64?

    @BasicProperty
    public private(set) var pageOuts: UInt64?

    @BasicProperty
    public private(set) var faults: UInt64?

    @BasicProperty
    public private(set) var copyOnWrites: UInt64?

    @BasicProperty
    public private(set) var lookups: UInt64?

    @BasicProperty
    public private(set) var hits: UInt64?

    @BasicProperty
    public private(set) var purgedPages: UInt64?

    @BasicProperty
    public private(set) var purgeablePages: UInt32?

    @BasicProperty
    public private(set) var speculativePages: UInt32?

    @BasicProperty
    public private(set) var decompressedPages: UInt64?

    @BasicProperty
    public private(set) var compressedPages: UInt64?

    @BasicProperty
    public private(set) var swappedInPages: UInt64?

    @BasicProperty
    public private(set) var swappedOutPages: UInt64?

    @BasicProperty
    public private(set) var compressorPages: UInt32?

    @BasicProperty
    public private(set) var uncompressedCompressorPages: UInt64?

    @BasicProperty
    public private(set) var throttledPages: UInt32?

    @BasicProperty
    public private(set) var externalPages: UInt32?

    @BasicProperty
    public private(set) var internalPages: UInt32?

    public var allProperties: [any Property] {
        [
            $total,
            $freePages,
            $activePages,
            $inactivePages,
            $wiredPages,
            $zeroFillPages,
            $reactivatedPages,
            $pageIns,
            $pageOuts,
            $faults,
            $copyOnWrites,
            $lookups,
            $hits,
            $purgedPages,
            $purgeablePages,
            $speculativePages,
            $decompressedPages,
            $compressedPages,
            $swappedInPages,
            $swappedOutPages,
            $compressorPages,
            $uncompressedCompressorPages,
            $throttledPages,
            $externalPages,
            $internalPages,
        ]
    }

    private let processInfo: ProcessInfo

    public init(processInfo: ProcessInfo = .processInfo) {
        id = SourceIdentifier(sourceKind: .memoryStatistics)
        self.processInfo = processInfo
        _total = MeasurementProperty(
            id: id.identifierForChildPropertyWithId("total"),
            value: Double(processInfo.physicalMemory),
            unit: .bytes
        )
        _freePages = BasicProperty(
            id: id.identifierForChildPropertyWithId("freePages")
        )
        _activePages = BasicProperty(
            id: id.identifierForChildPropertyWithId("activePages")
        )
        _inactivePages = BasicProperty(
            id: id.identifierForChildPropertyWithId("inactivePages")
        )
        _wiredPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("wiredPages")
        )
        _zeroFillPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("zeroFillPages")
        )
        _reactivatedPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("reactivatedPages")
        )
        _pageIns = BasicProperty(
            id: id.identifierForChildPropertyWithId("pageIns")
        )
        _pageOuts = BasicProperty(
            id: id.identifierForChildPropertyWithId("pageOuts")
        )
        _faults = BasicProperty(
            id: id.identifierForChildPropertyWithId("faults")
        )
        _copyOnWrites = BasicProperty(
            id: id.identifierForChildPropertyWithId("copyOnWrites")
        )
        _lookups = BasicProperty(
            id: id.identifierForChildPropertyWithId("lookups")
        )
        _hits = BasicProperty(
            id: id.identifierForChildPropertyWithId("hits")
        )
        _purgedPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("purgedPages")
        )
        _purgeablePages = BasicProperty(
            id: id.identifierForChildPropertyWithId("purgeablePages")
        )
        _speculativePages = BasicProperty(
            id: id.identifierForChildPropertyWithId("speculativePages")
        )
        _decompressedPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("decompressedPages")
        )
        _compressedPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("compressedPages")
        )
        _swappedInPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("swappedInPages")
        )
        _swappedOutPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("swappedOutPages")
        )
        _compressorPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("compressorPages")
        )
        _uncompressedCompressorPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("uncompressedCompressorPages")
        )
        _throttledPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("throttledPages")
        )
        _externalPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("externalPages")
        )
        _internalPages = BasicProperty(
            id: id.identifierForChildPropertyWithId("internalPages")
        )
    }

    @discardableResult
    public func updateValues() -> [any Property] {
        _total.updateMeasuredValueIfDifferent(Double(processInfo.physicalMemory))

        if let stats = vmStatistics() {
            _freePages.updateValueIfDifferent(stats.free_count)
            _activePages.updateValueIfDifferent(stats.active_count)
            _inactivePages.updateValueIfDifferent(stats.inactive_count)
            _wiredPages.updateValueIfDifferent(stats.wire_count)
            _zeroFillPages.updateValueIfDifferent(stats.zero_fill_count)
            _reactivatedPages.updateValueIfDifferent(stats.reactivations)
            _pageIns.updateValueIfDifferent(stats.pageins)
            _pageOuts.updateValueIfDifferent(stats.pageouts)
            _faults.updateValueIfDifferent(stats.faults)
            _copyOnWrites.updateValueIfDifferent(stats.cow_faults)
            _lookups.updateValueIfDifferent(stats.lookups)
            _hits.updateValueIfDifferent(stats.hits)
            _purgedPages.updateValueIfDifferent(stats.purges)
            _purgeablePages.updateValueIfDifferent(stats.purgeable_count)
            _speculativePages.updateValueIfDifferent(stats.speculative_count)
            _decompressedPages.updateValueIfDifferent(stats.decompressions)
            _compressedPages.updateValueIfDifferent(stats.compressions)
            _swappedInPages.updateValueIfDifferent(stats.swapins)
            _swappedOutPages.updateValueIfDifferent(stats.swapouts)
            _compressorPages.updateValueIfDifferent(stats.compressor_page_count)
            _uncompressedCompressorPages.updateValueIfDifferent(stats.total_uncompressed_pages_in_compressor)
            _throttledPages.updateValueIfDifferent(stats.throttled_count)
            _externalPages.updateValueIfDifferent(stats.external_page_count)
            _internalPages.updateValueIfDifferent(stats.internal_page_count)
        } else {
            _freePages.updateValue(nil)
            _activePages.updateValue(nil)
            _inactivePages.updateValue(nil)
            _wiredPages.updateValue(nil)
            _zeroFillPages.updateValue(nil)
            _reactivatedPages.updateValue(nil)
            _pageIns.updateValue(nil)
            _pageOuts.updateValue(nil)
            _faults.updateValue(nil)
            _copyOnWrites.updateValue(nil)
            _lookups.updateValue(nil)
            _hits.updateValue(nil)
            _purgedPages.updateValue(nil)
            _purgeablePages.updateValue(nil)
            _speculativePages.updateValue(nil)
            _decompressedPages.updateValue(nil)
            _compressedPages.updateValue(nil)
            _swappedInPages.updateValue(nil)
            _swappedOutPages.updateValue(nil)
            _compressorPages.updateValue(nil)
            _uncompressedCompressorPages.updateValue(nil)
            _throttledPages.updateValue(nil)
            _externalPages.updateValue(nil)
            _internalPages.updateValue(nil)
        }

        return allProperties
    }

    private func vmStatistics() -> vm_statistics64? {
        var size = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.stride / MemoryLayout<integer_t>.stride)
        var hostInfo = vm_statistics64()

        let result = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &size)
            }
        }

        guard result == KERN_SUCCESS else { return nil }

        return hostInfo
    }
}
