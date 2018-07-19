import Foundation
import AdSupport

public final class Advertising: BasePollingSource, Source, ManuallyUpdatableValuesProvider {

    public static let availability: SourceAvailability = .available

    public let displayName = "Advertising"

    public private(set) var isTrackingEnabled: GenericValue<Bool, Boolean>

    public private(set) var identifier: GenericValue<UUID, None>

    public var allValues: [AnyValue] {
        return [
            isTrackingEnabled.asAny(),
            identifier.asAny(),
        ]
    }

    public override init() {
        let manager = ASIdentifierManager.shared()
        isTrackingEnabled = GenericValue(
            displayName: "Is Tracking Enabled",
            backingValue: manager.isAdvertisingTrackingEnabled,
            unit: Boolean(trueString: "Yes", falseString: "No")
        )

        identifier = GenericValue(
            displayName: "Identifier",
            backingValue: manager.advertisingIdentifier,
            formattedValue: manager.formattedIdentifierValue
        )
    }

    public func updateValues() -> [AnyValue] {
        let manager = ASIdentifierManager.shared()

        isTrackingEnabled.update(backingValue: manager.isAdvertisingTrackingEnabled)
        identifier.update(backingValue: manager.advertisingIdentifier, formattedValue: manager.formattedIdentifierValue)

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
