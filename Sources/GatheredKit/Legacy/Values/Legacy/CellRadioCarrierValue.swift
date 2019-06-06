import Foundation
import CoreTelephony

public extension CellRadio {
    public struct CarrierValue: Value, PropertiesProvider {

        public var allProperties: [AnyProperty] {
            return [
                name,
                mobileCountryCode,
                mobileNetworkCode,
                isoCountryCode,
                allowsVOIP
            ]
        }

        public var name: GenericUnitlessProperty<String?> {
            return GenericUnitlessValue(
                displayName: "Name",
                value: value?.carrierName,
                formattedValue: value?.carrierName == nil
                    ? "Unknown"
                    : nil,
                date: date
            )
        }

        public var mobileCountryCode: GenericUnitlessProperty<String?> {
            return GenericUnitlessValue(
                displayName: "Mobile Country Code",
                value: value?.mobileCountryCode,
                formattedValue: value?.mobileCountryCode == nil
                    ? "Unknown"
                    : nil,
                date: date
            )
        }

        public var mobileNetworkCode: GenericUnitlessProperty<String?> {
            return GenericUnitlessValue(
                displayName: "Mobile Network Code",
                value: value?.mobileNetworkCode,
                formattedValue: value?.mobileNetworkCode == nil
                    ? "Unknown"
                    : nil,
                date: date
            )
        }

        public var isoCountryCode: GenericUnitlessProperty<String?> {
            return GenericUnitlessValue(
                displayName: "ISO Country Code",
                value: value?.isoCountryCode,
                formattedValue: value?.isoCountryCode == nil
                    ? "Unknown"
                    : nil,
                date: date
            )
        }

        public var allowsVOIP: GenericProperty<Bool?, Boolean> {
            return GenericValue(
                displayName: "Allows VOIP",
                value: value?.allowsVOIP,
                unit: Boolean(trueString: "Yes", falseString: "No"),
                date: date
            )
        }

        public let displayName = "Carrier"

        public let formattedValue: String? = nil

        public let value: CTCarrier?

        public let date: Date

        public init(value: CTCarrier? = nil, date: Date = Date()) {
            self.value = value
            self.date = date
        }

        /**
         Updates `self` to be a new `CellCarrierValue` instance with the
         updates properties provided

         - parameter value: The new value
         */
        public mutating func update(value: CTCarrier) {
            self = CarrierValue(value: value, date: Date())
        }

    }
}
