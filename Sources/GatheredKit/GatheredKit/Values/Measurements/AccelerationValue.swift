import Foundation

public typealias AccelerationValue = MeasurementProperty<UnitAcceleration>
public typealias OptionalAccelerationValue = OptionalMeasurementProperty<UnitAcceleration>

extension AnyProperty {

    static func acceleration(
        displayName: String,
        value: Double,
        unit: UnitAcceleration,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AccelerationValue {
        return .init(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    static func acceleration(
        displayName: String,
        value: Double? = nil,
        unit: UnitAcceleration,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAccelerationValue {
        return .init(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    static func metersPerSecondSquared(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AccelerationValue {
        return .init(displayName: displayName, value: value, unit: .metersPerSecondSquared, formatter: formatter, date: date)
    }

    static func metersPerSecondSquared(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAccelerationValue {
        return .init(displayName: displayName, value: value, unit: .metersPerSecondSquared, formatter: formatter, date: date)
    }

    static func gravity(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> AccelerationValue {
        return .init(displayName: displayName, value: value, unit: .gravity, formatter: formatter, date: date)
    }

    static func gravity(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalAccelerationValue {
        return .init(displayName: displayName, value: value, unit: .gravity, formatter: formatter, date: date)
    }

}
