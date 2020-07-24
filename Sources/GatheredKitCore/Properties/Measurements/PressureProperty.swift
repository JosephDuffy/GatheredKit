import Foundation

public typealias PressureProperty = MeasurementProperty<UnitPressure>
public typealias OptionalPressureProperty = OptionalMeasurementProperty<UnitPressure>

extension AnyProperty {

    public static func pressure(
        displayName: String,
        value: Double,
        unit: UnitPressure,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> PressureProperty {
        return .init(
            displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func pressure(
        displayName: String,
        value: Double? = nil,
        unit: UnitPressure,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalPressureProperty {
        return .init(
            displayName: displayName, value: value, unit: unit, formatter: formatter, date: date)
    }

    public static func kilopascals(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> PressureProperty {
        return .init(
            displayName: displayName, value: value, unit: .kilopascals, formatter: formatter,
            date: date)
    }

    public static func kilopascals(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalPressureProperty {
        return .init(
            displayName: displayName, value: value, unit: .kilopascals, formatter: formatter,
            date: date)
    }

}
