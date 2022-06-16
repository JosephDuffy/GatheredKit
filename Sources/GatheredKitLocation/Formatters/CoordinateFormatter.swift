import CoreLocation
import Foundation

public final class CoordinateFormatter: Formatter {
    public let numberFormatter: NumberFormatter

    public override init() {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 8
        formatter.decimalSeparator = "."
        numberFormatter = formatter
        super.init()
    }

    public init(numberFormatter: NumberFormatter) {
        self.numberFormatter = numberFormatter

        super.init()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard
            let numberFormatter = aDecoder.decodeObject(forKey: "numberFormatter")
            as? NumberFormatter
        else { return nil }

        self.init(numberFormatter: numberFormatter)
    }

    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)

        aCoder.encode(numberFormatter, forKey: "numberFormatter")
    }

    public override func string(for obj: Any?) -> String? {
        guard
            let coordinate = obj as? CLLocationCoordinate2D,
            let latitudeString = numberFormatter.string(from: NSNumber(value: coordinate.latitude)),
            let longitudeString = numberFormatter.string(
                from: NSNumber(value: coordinate.longitude))
        else {
            return nil
        }

        return latitudeString + ", " + longitudeString
    }

    public override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `CLLocationCoordinate2D` is not a class.
        false
    }
}
