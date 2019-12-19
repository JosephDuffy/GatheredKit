import Foundation

public final class PressureValue: MeasurementProperty<UnitPressure> { }
public final class OptionalPressureValue: OptionalMeasurementProperty<UnitPressure> { }

extension AnyProperty {

    static func pressure(
        displayName: String,
        value: Double,
        unit: UnitPressure,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> PressureValue {
        return .init(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    static func pressure(
        displayName: String,
        value: Double? = nil,
        unit: UnitPressure,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalPressureValue {
        return .init(displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    static func kilopascals(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> PressureValue {
        return .init(displayName: displayName, value: value, unit: .kilopascals, formatter: formatter, date: date)
    }

    static func kilopascals(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalPressureValue {
        return .init(displayName: displayName, value: value, unit: .kilopascals, formatter: formatter, date: date)
    }

}
