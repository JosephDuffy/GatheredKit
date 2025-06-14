import Foundation

public typealias SpeedProperty = MeasurementProperty<UnitSpeed, Never>
public typealias OptionalSpeedProperty = OptionalMeasurementProperty<UnitSpeed>

extension Property {
    public static func speed(
        id: PropertyIdentifier,
        value: Double,
        unit: UnitSpeed,
        date: Date = Date()
    ) -> SpeedProperty {
        SpeedProperty(
            id: id,
            value: value,
            unit: unit,
            date: date
        )
    }

    public static func metersPerSecond(
        id: PropertyIdentifier,
        value: Double,
        date: Date = Date()
    ) -> SpeedProperty {
        SpeedProperty(
            id: id,
            value: value,
            unit: .metersPerSecond,
            date: date
        )
    }

    public static func speed(
        id: PropertyIdentifier,
        value: Double? = nil,
        unit: UnitSpeed,
        date: Date = Date()
    ) -> OptionalSpeedProperty {
        .init(
            id: id,
            unit: unit,
            value: value,
            date: date
        )
    }

    public static func metersPerSecond(
        id: PropertyIdentifier,
        value: Double? = nil,
        date: Date = Date()
    ) -> OptionalSpeedProperty {
        .init(
            id: id,
            unit: .metersPerSecond,
            value: value,
            date: date
        )
    }
}
