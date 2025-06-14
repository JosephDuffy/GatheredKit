import Foundation

extension Property {
    public static func measurement<Unit: Foundation.Unit>(
        id: PropertyIdentifier,
        value: Double,
        unit: Unit,
        date: Date = Date()
    ) -> MeasurementProperty<Unit, Never> {
        MeasurementProperty<Unit, Never>(
            id: id,
            value: value,
            unit: unit,
            date: date
        )
    }

    public static func measurement<Unit: Foundation.Unit>(
        id: PropertyIdentifier,
        measurement: Measurement<Unit>,
        date: Date = Date()
    ) -> MeasurementProperty<Unit, Never> {
        MeasurementProperty<Unit, Never>(
            id: id,
            measurement: measurement,
            date: date
        )
    }

    public static func measurement<Unit: Foundation.Unit>(
        id: PropertyIdentifier,
        value: Double? = nil,
        unit: Unit,
        date: Date = Date()
    ) -> OptionalMeasurementProperty<Unit> {
        OptionalMeasurementProperty<Unit>(
            id: id,
            unit: unit,
            value: value,
            date: date
        )
    }

    public static func measurement<Unit: Foundation.Unit>(
        id: PropertyIdentifier,
        measurement: Measurement<Unit>,
        date: Date = Date()
    ) -> OptionalMeasurementProperty<Unit> {
        OptionalMeasurementProperty<Unit>(
            id: id,
            measurement: measurement,
            date: date
        )
    }
}
