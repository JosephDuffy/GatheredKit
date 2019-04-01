import Foundation
import AdSupport

public final class Advertising: BasePollingSource, Source, CustomisableUpdateIntervalControllable, ManuallyUpdatableValuesProvider {

    public static var defaultUpdateInterval: TimeInterval = 1

    public static let availability: SourceAvailability = .available

    public static let name = "Advertising"

    public private(set) var isTrackingEnabled: Value<Bool?>

    public private(set) var identifier: Value<UUID>

    public var allValues: [AnyValue] {
        return [isTrackingEnabled, identifier]
    }

    public override init() {
        let manager = ASIdentifierManager.shared()
        isTrackingEnabled = Value(
            displayName: "Is Tracking Enabled",
            backingValue: manager.isAdvertisingTrackingEnabled
        )

        identifier = Value(
            displayName: "Identifier",
            backingValue: manager.advertisingIdentifier,
            formattedValue: manager.formattedIdentifierValue
        )
    }

    public func updateValues() -> [AnyValue] {
        let manager = ASIdentifierManager.shared()

        isTrackingEnabled.update(
            backingValue: manager.isAdvertisingTrackingEnabled
        )
        identifier.update(
            backingValue: manager.advertisingIdentifier,
            formattedValue: manager.formattedIdentifierValue
        )

        return allValues
    }

}

private extension ASIdentifierManager {

    var formattedIdentifierValue: String {
        if #available(iOS 10.0, *), !isAdvertisingTrackingEnabled {
            // `advertisingIdentifier` will be all zeroes
            return "Unavailable"
        } else {
            return advertisingIdentifier.uuidString
        }
    }

}
