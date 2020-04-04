import Foundation

extension AnyProperty {

    public static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        value: Double,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> MeasurementProperty<Unit> {
        let measurement = Measurement(value: value, unit: unit)
        return MeasurementProperty<Unit>(
            displayName: displayName,
            value: measurement,
            formatter: formatter,
            date: date
        )
    }

    public static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        value: Double? = nil,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalMeasurementProperty<Unit> {
        let measurement: Measurement<Unit>?
        if let value = value {
            measurement = Measurement(value: value, unit: unit)
        } else {
            measurement = nil
        }
        return OptionalMeasurementProperty<Unit>(
            displayName: displayName,
            value: measurement,
            formatter: formatter,
            date: date
        )
    }

}
