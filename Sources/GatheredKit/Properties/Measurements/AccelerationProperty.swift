import Foundation

public typealias AccelerationProperty = MeasurementProperty<UnitAcceleration, Never>
public typealias OptionalAccelerationProperty = OptionalMeasurementProperty<UnitAcceleration>

extension Property {
    public static func acceleration(
        id: PropertyIdentifier,
        value: Double,
        unit: UnitAcceleration,
        date: Date = Date()
    ) -> AccelerationProperty {
        .init(
            id: id,
            value: value,
            unit: unit,
            date: date
        )
    }

    public static func acceleration(
        id: PropertyIdentifier,
        value: Double? = nil,
        unit: UnitAcceleration,
        date: Date = Date()
    ) -> OptionalAccelerationProperty {
        .init(
            id: id,
            unit: unit,
            value: value,
            date: date
        )
    }

    public static func metersPerSecondSquared(
        id: PropertyIdentifier,
        value: Double,
        date: Date = Date()
    ) -> AccelerationProperty {
        .init(
            id: id,
            value: value,
            unit: .metersPerSecondSquared,
            date: date
        )
    }

    public static func metersPerSecondSquared(
        id: PropertyIdentifier,
        value: Double? = nil,
        date: Date = Date()
    ) -> OptionalAccelerationProperty {
        .init(
            id: id,
            unit: .metersPerSecondSquared,
            value: value,
            date: date
        )
    }

    public static func gravity(
        id: PropertyIdentifier,
        value: Double,
        date: Date = Date()
    ) -> AccelerationProperty {
        .init(
            id: id,
            value: value,
            unit: .gravity,
            date: date
        )
    }

    public static func gravity(
        id: PropertyIdentifier,
        value: Double? = nil,
        date: Date = Date()
    ) -> OptionalAccelerationProperty {
        .init(
            id: id,
            unit: .gravity,
            value: value,
            date: date
        )
    }
}
