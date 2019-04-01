import Foundation

extension Value {

    public init<UnitType: Foundation.Unit>(
        displayName: String,
        value: Double,
        unit: UnitType,
        formatter: Formatter = Formatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) where ValueType == Measurement<UnitType>, Formatter == MeasurementFormatter {
        let measurement = Measurement<UnitType>(value: value, unit: unit)
        self.init(displayName: displayName, backingValue: measurement, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    public init<UnitType: Foundation.Unit>(
        displayName: String,
        value: Double?,
        unit: UnitType,
        formatter: Formatter = Formatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) where ValueType == Measurement<UnitType>?, Formatter == MeasurementFormatter {
        let measurement: Measurement<UnitType>?
        if let value = value {
            measurement = Measurement<UnitType>(value: value, unit: unit)
        } else {
            measurement = nil
        }
        self.init(displayName: displayName, backingValue: measurement, formatter: formatter, formattedValue: formattedValue, date: date)
    }

    public mutating func update<UnitType: Unit>(
        value: Double,
        unit: UnitType,
        formattedValue: String? = nil,
        date: Date = Date()
    ) where ValueType == Measurement<UnitType> {
        let measurement = Measurement<UnitType>(value: value, unit: self.backingValue.unit)
        self.update(backingValue: measurement, formattedValue: formattedValue, date: date)
    }

    public mutating func update<UnitType: Unit>(
        value: Double,
        formattedValue: String? = nil,
        date: Date = Date()
    ) where ValueType == Measurement<UnitType> {
        self.update(value: value, unit: backingValue.unit, formattedValue: formattedValue, date: date)
    }

    public mutating func update<UnitType: Unit>(
        value: Double?,
        unit: UnitType,
        formattedValue: String? = nil,
        date: Date = Date()
    ) where ValueType == Measurement<UnitType>? {
        let measurement: Measurement<UnitType>?
        if let value = value {
            measurement = Measurement<UnitType>(value: value, unit: unit)
        } else {
            measurement = nil
        }
        self.update(backingValue: measurement, formattedValue: formattedValue, date: date)
    }

    public mutating func update<UnitType: Unit>(
        value: Float,
        unit: UnitType,
        formattedValue: String? = nil,
        date: Date = Date()
    ) where ValueType == Measurement<UnitType> {
        self.update(value: Double(value), unit: unit, formattedValue: formattedValue, date: date)
    }

    public mutating func update<UnitType: Unit>(
        value: Float,
        formattedValue: String? = nil,
        date: Date = Date()
    ) where ValueType == Measurement<UnitType> {
        self.update(value: Double(value), unit: backingValue.unit, formattedValue: formattedValue, date: date)
    }

    public mutating func update<UnitType: Unit>(
        value: Float?,
        unit: UnitType,
        formattedValue: String? = nil,
        date: Date = Date()
    ) where ValueType == Measurement<UnitType>? {
        self.update(value: value.map { Double($0) }, unit: unit, formattedValue: formattedValue, date: date)
    }

}
