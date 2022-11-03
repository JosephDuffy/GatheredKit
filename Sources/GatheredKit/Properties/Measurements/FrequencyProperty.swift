import Foundation

public typealias FrequencyProperty = MeasurementProperty<UnitFrequency>
public typealias OptionalFrequencyProperty = OptionalMeasurementProperty<UnitFrequency>

extension Property {
    public static func frequency(
        id: PropertyIdentifier,
        value: Double,
        unit: UnitFrequency,
        date: Date = Date()
    ) -> FrequencyProperty {
        .init(
            id: id,
            value: value,
            unit: unit,
            date: date
        )
    }

    public static func frequency(
        id: PropertyIdentifier,
        value: Double? = nil,
        unit: UnitFrequency,
        date: Date = Date()
    ) -> OptionalFrequencyProperty {
        .init(
            id: id,
            unit: unit,
            value: value,
            date: date
        )
    }

    public static func radiansPerSecond(
        id: PropertyIdentifier,
        value: Double,
        date: Date = Date()
    ) -> FrequencyProperty {
        .init(
            id: id,
            value: value,
            unit: .radiansPerSecond,
            date: date
        )
    }

    public static func radiansPerSecond(
        id: PropertyIdentifier,
        value: Double? = nil,
        date: Date = Date()
    ) -> OptionalFrequencyProperty {
        .init(
            id: id,
            unit: .radiansPerSecond,
            value: value,
            date: date
        )
    }
}
