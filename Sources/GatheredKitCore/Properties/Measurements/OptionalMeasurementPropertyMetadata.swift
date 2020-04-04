import Foundation

open class OptionalReadOnlyMeasurementProperty<Unit: Foundation.Dimension>: ReadOnlyProperty<Measurement<Unit>?, MeasurementFormatter> {

    public private(set) var unit: Unit

    public var measurement: Measurement<Unit>? {
        return value
    }

    public required init(
        displayName: String,
        value: Double?,
        unit: Unit = .baseUnit(),
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        self.unit = unit
        let measurement: Measurement<Unit>?
        if let value = value {
            measurement = Measurement<Unit>(value: value, unit: unit)
        } else {
            measurement = nil
        }
        super.init(displayName: displayName, value: measurement, formatter: formatter, date: date)
    }

    public required init(
        displayName: String,
        value measurement: Measurement<Unit>? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) {
        unit = measurement?.unit ?? .baseUnit()
        super.init(displayName: displayName, value: measurement, formatter: formatter, date: date)
    }

}
