import Foundation
import AdSupport

public final class Advertising: BasePollingSource, Source, CustomisableUpdateIntervalControllable, ManuallyUpdatablePropertiesProvider {

    public static var defaultUpdateInterval: TimeInterval = 1

    public static let availability: SourceAvailability = .available

    public static let name = "Advertising"

    public private(set) var isTrackingEnabled: Property<Bool?>

    public private(set) var identifier: Property<UUID>

    public var allProperties: [AnyProperty] {
        return [isTrackingEnabled, identifier]
    }

    public override init() {
        let manager = ASIdentifierManager.shared()
        isTrackingEnabled = Value(
            displayName: "Is Tracking Enabled",
            value: manager.isAdvertisingTrackingEnabled
        )

        identifier = Value(
            displayName: "Identifier",
            value: manager.advertisingIdentifier,
            formattedValue: manager.formattedIdentifierValue
        )
    }

    public func updateValues() -> [AnyProperty] {
        let manager = ASIdentifierManager.shared()

        isTrackingEnabled.update(
            value: manager.isAdvertisingTrackingEnabled
        )
        identifier.update(
            value: manager.advertisingIdentifier,
            formattedValue: manager.formattedIdentifierValue
        )

        return allProperties
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
