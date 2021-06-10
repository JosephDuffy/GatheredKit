import Foundation

public typealias AccelerationProperty = MeasurementProperty<UnitAcceleration>
public typealias OptionalAccelerationProperty = OptionalMeasurementProperty<UnitAcceleration>

extension AnyProperty {

    public static func acceleration(
        displayName: String,
        value: Double,
        unit: UnitAcceleration,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AccelerationProperty {
        return .init(
            displayName: displayName,
            value: value,
            unit: unit,
            formatter: formatter,
            date: date
        )
    }

    public static func acceleration(
        displayName: String,
        value: Double? = nil,
        unit: UnitAcceleration,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAccelerationProperty {
        return .init(
            displayName: displayName,
            value: value,
            unit: unit,
            formatter: formatter,
            date: date
        )
    }

    public static func metersPerSecondSquared(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AccelerationProperty {
        return .init(
            displayName: displayName,
            value: value,
            unit: .metersPerSecondSquared,
            formatter: formatter,
            date: date
        )
    }

    public static func metersPerSecondSquared(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAccelerationProperty {
        return .init(
            displayName: displayName,
            value: value,
            unit: .metersPerSecondSquared,
            formatter: formatter,
            date: date
        )
    }

    public static func gravity(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AccelerationProperty {
        return .init(
            displayName: displayName,
            value: value,
            unit: .gravity,
            formatter: formatter,
            date: date
        )
    }

    public static func gravity(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAccelerationProperty {
        return .init(
            displayName: displayName,
            value: value,
            unit: .gravity,
            formatter: formatter,
            date: date
        )
    }

}
