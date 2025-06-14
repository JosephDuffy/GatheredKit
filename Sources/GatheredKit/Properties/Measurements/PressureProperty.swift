import Foundation

public typealias PressureProperty = MeasurementProperty<UnitPressure, Never>
public typealias OptionalPressureProperty = OptionalMeasurementProperty<UnitPressure>

extension Property {
    public static func pressure(
        id: PropertyIdentifier,
        value: Double,
        unit: UnitPressure,
        date: Date = Date()
    ) -> PressureProperty {
        .init(
            id: id,
            value: value,
            unit: unit,
            date: date
        )
    }

    public static func pressure(
        id: PropertyIdentifier,
        value: Double? = nil,
        unit: UnitPressure,
        date: Date = Date()
    ) -> OptionalPressureProperty {
        .init(
            id: id,
            unit: unit,
            value: value,
            date: date
        )
    }

    public static func kilopascals(
        id: PropertyIdentifier,
        value: Double,
        date: Date = Date()
    ) -> PressureProperty {
        .init(
            id: id,
            value: value,
            unit: .kilopascals,
            date: date
        )
    }

    public static func kilopascals(
        id: PropertyIdentifier,
        value: Double? = nil,
        date: Date = Date()
    ) -> OptionalPressureProperty {
        .init(
            id: id,
            unit: .kilopascals,
            value: value,
            date: date
        )
    }
}
