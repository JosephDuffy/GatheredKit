import Foundation

public class MeasurementValue<Unit: Foundation.Unit>: Value<Measurement<Unit>, MeasurementFormatter> {
        
    public convenience init(
        displayName: String,
        value: Double,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        let measurement = Measurement(value: value, unit: unit)
        self.init(displayName: displayName, backingValue: measurement, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
    public func update(
        value: Double,
        unit: Unit,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        let measurement = Measurement(value: value, unit: self.backingValue.unit)
        self.update(backingValue: measurement, formattedValue: formattedValue, date: date)
    }
    
    public func update(
        value: Double,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        self.update(value: value, unit: backingValue.unit, formattedValue: formattedValue, date: date)
    }
    
    public func update(
        value: Float,
        unit: Unit,
        formattedValue: String? = nil,
        date: Date = Date()
    )  {
        self.update(value: Double(value), unit: unit, formattedValue: formattedValue, date: date)
    }
    
    public func update(
        value: Float,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        self.update(value: Double(value), unit: backingValue.unit, formattedValue: formattedValue, date: date)
    }
    
}

public class OptionalMeasurementValue<Unit: Foundation.Unit>: OptionalValue<Measurement<Unit>, MeasurementFormatter> {
    
    public convenience init(
        displayName: String,
        value: Double?,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        let measurement: Measurement<Unit>?
        if let value = value {
            measurement = Measurement<Unit>(value: value, unit: unit)
        } else {
            measurement = nil
        }
        self.init(displayName: displayName, backingValue: measurement, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
    public func update(
        value: Double?,
        unit: Unit,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        if let value = value {
            update(value: value, unit: unit, formattedValue: formattedValue, date: date)
        } else {
            update(backingValue: nil, formattedValue: formattedValue, date: date)
        }
    }
    
    public func update(
        value: Double,
        unit: Unit,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        let measurement = Measurement<Unit>(value: value, unit: unit)
        self.update(backingValue: measurement, formattedValue: formattedValue, date: date)
    }
    
    public func update(
        value: Float?,
        unit: Unit,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        self.update(value: value.map { Double($0) }, unit: unit, formattedValue: formattedValue, date: date)
    }
    
}

public extension AnyValue {

    static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        value: Double,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> MeasurementValue<Unit> {
        let backingValue = Measurement(value: value, unit: unit)
        return MeasurementValue<Unit>(
            displayName: displayName,
            backingValue: backingValue,
            formatter: formatter,
            formattedValue: formattedValue,
            date: date
        )
    }

    static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        value: Double? = nil,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> OptionalMeasurementValue<Unit> {
        let backingValue: Measurement<Unit>?
        if let value = value {
            backingValue = Measurement(value: value, unit: unit)
        } else {
            backingValue = nil
        }
        return OptionalMeasurementValue<Unit>(
            displayName: displayName,
            backingValue: backingValue,
            formatter: formatter,
            formattedValue: formattedValue,
            date: date
        )
    }

}
