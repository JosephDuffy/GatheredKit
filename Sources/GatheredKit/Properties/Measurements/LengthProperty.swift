import Foundation

public typealias LengthProperty = MeasurementProperty<UnitLength>
public typealias OptionalLengthProperty = OptionalMeasurementProperty<UnitLength>

extension Property {
    public static func length(
        id: PropertyIdentifier,
        value: Double,
        unit: UnitLength,
        date: Date = Date()
    ) -> LengthProperty {
        .init(
            id: id,
            value: value,
            unit: unit,
            date: date
        )
    }

    public static func length(
        id: PropertyIdentifier,
        value: Double? = nil,
        unit: UnitLength,
        date: Date = Date()
    ) -> OptionalLengthProperty {
        .init(
            id: id,
            unit: unit,
            value: value,
            date: date
        )
    }

    public static func meters(
        id: PropertyIdentifier,
        value: Double,
        date: Date = Date()
    ) -> LengthProperty {
        .init(
            id: id,
            value: value,
            unit: .meters,
            date: date
        )
    }

    public static func meters(
        id: PropertyIdentifier,
        value: Double? = nil,
        date: Date = Date()
    ) -> OptionalLengthProperty {
        .init(
            id: id,
            unit: .meters,
            value: value,
            date: date
        )
    }
}
