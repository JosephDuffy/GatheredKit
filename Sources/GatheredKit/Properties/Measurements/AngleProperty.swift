import Foundation

public typealias AngleProperty = MeasurementProperty<UnitAngle, Never>
public typealias OptionalAngleProperty = OptionalMeasurementProperty<UnitAngle>

extension Property {
    public static func angle(
        id: PropertyIdentifier,
        value: Double,
        unit: UnitAngle,
        date: Date = Date()
    ) -> AngleProperty {
        .init(
            id: id,
            value: value,
            unit: unit,
            date: date
        )
    }

    public static func angle(
        id: PropertyIdentifier,
        value: Double? = nil,
        unit: UnitAngle,
        date: Date = Date()
    ) -> OptionalAngleProperty {
        OptionalAngleProperty(
            id: id,
            unit: unit,
            value: value,
            date: date
        )
    }

    public static func degrees(
        id: PropertyIdentifier,
        value: Double,
        date: Date = Date()
    ) -> AngleProperty {
        .init(
            id: id,
            value: value,
            unit: .degrees,
            date: date
        )
    }

    public static func degrees(
        id: PropertyIdentifier,
        value: Double? = nil,
        date: Date = Date()
    ) -> OptionalAngleProperty {
        OptionalAngleProperty(
            id: id,
            unit: .degrees,
            value: value,
            date: date
        )
    }

    public static func radians(
        id: PropertyIdentifier,
        value: Double,
        date: Date = Date()
    ) -> AngleProperty {
        .init(
            id: id,
            value: value,
            unit: .radians,
            date: date
        )
    }

    public static func radians(
        id: PropertyIdentifier,
        value: Double? = nil,
        date: Date = Date()
    ) -> OptionalAngleProperty {
        .init(
            id: id,
            unit: .radians,
            value: value,
            date: date
        )
    }
}
