import Foundation

public typealias MagneticFieldProperty = MeasurementProperty<UnitMagneticField>
public typealias OptionalMagneticFieldProperty = OptionalMeasurementProperty<UnitMagneticField>

extension Property {
    public static func magneticField(
        id: PropertyIdentifier,
        value: Double,
        unit: UnitMagneticField,
        date: Date = Date()
    ) -> MagneticFieldProperty {
        .init(
            id: id,
            value: value,
            unit: unit,
            date: date
        )
    }

    public static func magneticField(
        id: PropertyIdentifier,
        value: Double? = nil,
        unit: UnitMagneticField,
        date: Date = Date()
    ) -> OptionalMagneticFieldProperty {
        .init(
            id: id,
            unit: unit,
            value: value,
            date: date
        )
    }

    public static func tesla(
        id: PropertyIdentifier,
        value: Double,
        date: Date = Date()
    ) -> MagneticFieldProperty {
        .init(
            id: id,
            value: value,
            unit: .tesla,
            date: date
        )
    }

    public static func tesla(
        id: PropertyIdentifier,
        value: Double? = nil,
        date: Date = Date()
    ) -> OptionalMagneticFieldProperty {
        .init(
            id: id,
            unit: .microTesla,
            value: value,
            date: date
        )
    }

    public static func microTesla(
        id: PropertyIdentifier,
        value: Double,
        date: Date = Date()
    ) -> MagneticFieldProperty {
        .init(
            id: id,
            value: value,
            unit: .microTesla,
            date: date
        )
    }

    public static func microTesla(
        id: PropertyIdentifier,
        value: Double? = nil,
        date: Date = Date()
    ) -> OptionalMagneticFieldProperty {
        .init(
            id: id,
            unit: .microTesla,
            value: value,
            date: date
        )
    }
}
