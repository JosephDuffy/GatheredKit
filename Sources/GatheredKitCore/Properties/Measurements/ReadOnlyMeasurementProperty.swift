import Foundation

@available(*, deprecated, renamed: "MeasurementProperty")
public typealias MeasurementPropertyMetadata = ReadOnlyMeasurementProperty

open class ReadOnlyMeasurementProperty<Unit: Foundation.Unit>: ReadOnlyProperty<Measurement<Unit>, MeasurementFormatter> {

    public var measurement: Measurement<Unit> {
        return value
    }

    public var unit: Unit {
        return measurement.unit
    }

    public var measuredValue: Double {
        return measurement.value
    }

}
