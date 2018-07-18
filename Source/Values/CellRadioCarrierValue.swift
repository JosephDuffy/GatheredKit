import Foundation
import CoreTelephony

public extension CellRadio {
    public struct CarrierValue: Value, ValuesProvider {

        public var allValues: [AnyValue] {
            return [
                name.asAny(),
                mobileCountryCode.asAny(),
                mobileNetworkCode.asAny(),
                isoCountryCode.asAny(),
                allowsVOIP.asAny(),
            ]
        }

        public var name: GenericValue<String?, None> {
            return GenericValue(
                displayName: "Name",
                backingValue: backingValue?.carrierName,
                formattedValue: backingValue?.carrierName == nil ? "Unknown" : nil,
                date: date
            )
        }

        public var mobileCountryCode: GenericValue<String?, None> {
            return GenericValue(
                displayName: "Mobile Country Code",
                backingValue: backingValue?.mobileCountryCode,
                formattedValue: backingValue?.mobileCountryCode == nil ? "Unknown" : nil,
                date: date
            )
        }

        public var mobileNetworkCode: GenericValue<String?, None> {
            return GenericValue(
                displayName: "Mobile Network Code",
                backingValue: backingValue?.mobileNetworkCode,
                formattedValue: backingValue?.mobileNetworkCode == nil ? "Unknown" : nil,
                date: date
            )
        }

        public var isoCountryCode: GenericValue<String?, None> {
            return GenericValue(
                displayName: "ISO Country Code",
                backingValue: backingValue?.isoCountryCode,
                formattedValue: backingValue?.isoCountryCode == nil ? "Unknown" : nil,
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

        public let unit = None()

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
