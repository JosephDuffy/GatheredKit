import Foundation

open class SpeedFormatter: MeasurementFormatter {
    open override func string(from measurement: Measurement<Unit>) -> String {
        if measurement.value < 0 {
            return "Invalid"
        } else {
            return super.string(from: measurement)
        }
    }

    open override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        #warning("TODO: Implement")
        fatalError("Unimplemented")
    }
}
