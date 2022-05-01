import Foundation

open class CourseFormatter: MeasurementFormatter {
    open override func string(from measurement: Measurement<Unit>) -> String {
        if measurement.value < 0 {
            return "Invalid"
        } else {
            return super.string(from: measurement)
        }
    }

    public override func getObjectValue(
        _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
        for string: String,
        errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
    ) -> Bool {
        // `Mesaurement` is not a class.
        false
    }
}
