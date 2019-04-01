import Foundation

public final class Storage: BasePollingSource, Source, CustomisableUpdateIntervalControllable, ManuallyUpdatableValuesProvider {

    public static var defaultUpdateInterval: TimeInterval = 1

    public static let availability: SourceAvailability = .available

    public static let name = "Storage"

    public private(set) var capacity: GenericValue<Int64?, Byte>

    public private(set) var available: GenericValue<Int64?, Byte>

    public private(set) var free: GenericValue<Int64?, Byte>

    public var allValues: [AnyValue] {
        return [capacity, available, free]
    }

    public override init() {
        capacity = GenericValue(
            displayName: "Capacity",
            unit: Byte(countStyle: .file)
        )
        available = GenericValue(
            displayName: "Available",
            unit: Byte(countStyle: .file)
        )
        free = GenericValue(displayName: "Free", unit: Byte(countStyle: .file))
    }

    public func updateValues() -> [AnyValue] {
        let paths = NSSearchPathForDirectoriesInDomains(
            .documentDirectory,
            .userDomainMask,
            true
        )

        guard let path = paths.first else { return allValues }

        do {
            let dictionary = try FileManager.default.attributesOfFileSystem(
                forPath: path
            )
            let capacity = dictionary[FileAttributeKey.systemSize] as? NSNumber
            let free = dictionary[FileAttributeKey.systemFreeSize] as? NSNumber

            if capacity != nil {
                self.capacity.update(backingValue: capacity?.int64Value)
            }

            if free != nil {
                self.free.update(backingValue: free?.int64Value)
            }

            if let capacity = capacity, let free = free {
                let available = capacity.int64Value - free.int64Value
                self.available.update(backingValue: available)
            }

        } catch {
            print("Error getting Storage data", error)
        }

        return allValues
    }

}
