import Foundation
import CoreTelephony

public extension CellRadio {
    public struct CarrierValue: TypedValue, ValuesProvider {

        public var allValues: [Value] {
            return [
                name,
                mobileCountryCode,
                mobileNetworkCode,
                isoCountryCode,
                allowsVOIP
            ]
        }

        public var name: GenericUnitlessValue<String?> {
            return GenericUnitlessValue(
                displayName: "Name",
                backingValue: backingValue?.carrierName,
                formattedValue: backingValue?.carrierName == nil
                    ? "Unknown"
                    : nil,
                date: date
            )
        }

        public var mobileCountryCode: GenericUnitlessValue<String?> {
            return GenericUnitlessValue(
                displayName: "Mobile Country Code",
                backingValue: backingValue?.mobileCountryCode,
                formattedValue: backingValue?.mobileCountryCode == nil
                    ? "Unknown"
                    : nil,
                date: date
            )
        }

        public var mobileNetworkCode: GenericUnitlessValue<String?> {
            return GenericUnitlessValue(
                displayName: "Mobile Network Code",
                backingValue: backingValue?.mobileNetworkCode,
                formattedValue: backingValue?.mobileNetworkCode == nil
                    ? "Unknown"
                    : nil,
                date: date
            )
        }

        public var isoCountryCode: GenericUnitlessValue<String?> {
            return GenericUnitlessValue(
                displayName: "ISO Country Code",
                backingValue: backingValue?.isoCountryCode,
                formattedValue: backingValue?.isoCountryCode == nil
                    ? "Unknown"
                    : nil,
                date: date
            )
        }

        public var allowsVOIP: GenericValue<Bool?, Boolean> {
            return GenericValue(
                displayName: "Allows VOIP",
                backingValue: backingValue?.allowsVOIP,
                unit: Boolean(trueString: "Yes", falseString: "No"),
                date: date
            )
        }

        public let displayName = "Carrier"

        public let formattedValue: String? = nil

        public let backingValue: CTCarrier?

        public let date: Date

        public init(backingValue: CTCarrier? = nil, date: Date = Date()) {
            self.backingValue = backingValue
            self.date = date
        }

        /**
         Updates `self` to be a new `CellCarrierValue` instance with the
         updates values provided

         - parameter backingValue: The new value
         */
        public mutating func update(backingValue: CTCarrier) {
            self = CarrierValue(backingValue: backingValue, date: Date())
        }

    }
}
