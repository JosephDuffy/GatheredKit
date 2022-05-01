import Foundation

open class CourseFormatter: MeasurementFormatter {
    open func string(from measurement: Measurement<Unit>) -> String {
        if measurement.value < 0 {
            return "Invalid"
        } else {
            return super.string(from: measurement)
        }
    }
}
