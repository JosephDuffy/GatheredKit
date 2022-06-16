import Foundation

public typealias LengthProperty = MeasurementProperty<UnitLength>
public typealias OptionalLengthProperty = OptionalMeasurementProperty<UnitLength>

extension AnyProperty {
    public static func length(
        displayName: String,
        value: Double,
        unit: UnitLength,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> LengthProperty {
        .init(
            displayName: displayName, value: value, unit: unit, formatter: formatter, date: date
        )
    }

    public static func length(
        displayName: String,
        value: Double? = nil,
        unit: UnitLength,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalLengthProperty {
        .init(
            displayName: displayName, value: value, unit: unit, formatter: formatter, date: date
        )
    }

    public static func meters(
        displayName: String,
        value: Double,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> LengthProperty {
        .init(
            displayName: displayName, value: value, unit: .meters, formatter: formatter, date: date
        )
    }

    public static func meters(
        displayName: String,
        value: Double? = nil,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        date: Date = Date()
    ) -> OptionalLengthProperty {
        .init(
            displayName: displayName, value: value, unit: .meters, formatter: formatter, date: date
        )
    }
}
