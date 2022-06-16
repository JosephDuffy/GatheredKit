import Foundation

extension AnyProperty {
    public static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        value: Double,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> MeasurementProperty<Unit> {
        MeasurementProperty<Unit>(
            displayName: displayName,
            value: value,
            unit: unit,
            formatter: formatter,
            date: date
        )
    }

    public static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        measurement: Measurement<Unit>,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> MeasurementProperty<Unit> {
        MeasurementProperty<Unit>(
            displayName: displayName,
            measurement: measurement,
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
        OptionalMeasurementProperty<Unit>(
            displayName: displayName,
            value: value,
            unit: unit,
            formatter: formatter,
            date: date
        )
    }

    public static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        measurement: Measurement<Unit>,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalMeasurementProperty<Unit> {
        OptionalMeasurementProperty<Unit>(
            displayName: displayName,
            measurement: measurement,
            formatter: formatter,
            date: date
        )
    }
}
