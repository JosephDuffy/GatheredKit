import Foundation

public class MeasurementProperty<Unit: Foundation.Unit>: Property<Measurement<Unit>, MeasurementFormatter> {
    
    public var measurement: Measurement<Unit> {
        return value
    }
        
    public convenience init(
        displayName: String,
        value: Double,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        let measurement = Measurement(value: value, unit: unit)
        self.init(displayName: displayName, value: measurement, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
    public func update(
        value: Double,
        unit: Unit,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        let measurement = Measurement(value: value, unit: self.value.unit)
        self.update(value: measurement, formattedValue: formattedValue, date: date)
    }
    
    public func update(
        value: Double,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        self.update(value: value, unit: measurement.unit, formattedValue: formattedValue, date: date)
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
        self.update(value: Double(value), unit: measurement.unit, formattedValue: formattedValue, date: date)
    }
    
}

public class OptionalMeasurementProperty<Unit: Foundation.Unit>: OptionalProperty<Measurement<Unit>, MeasurementFormatter> {
    
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
        self.init(displayName: displayName, value: measurement, formatter: formatter, formattedValue: formattedValue, date: date)
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
            update(value: nil, formattedValue: formattedValue, date: date)
        }
    }
    
    public func update(
        value: Double,
        unit: Unit,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        let measurement = Measurement<Unit>(value: value, unit: unit)
        self.update(value: measurement, formattedValue: formattedValue, date: date)
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

public extension AnyProperty {

    static func measurement<Unit: Foundation.Unit>(
        displayName: String,
        value: Double,
        unit: Unit,
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) -> MeasurementProperty<Unit> {
        let measurement = Measurement(value: value, unit: unit)
        return MeasurementProperty<Unit>(
            displayName: displayName,
            value: measurement,
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
    ) -> OptionalMeasurementProperty<Unit> {
        let measurement: Measurement<Unit>?
        if let value = value {
            measurement = Measurement(value: value, unit: unit)
        } else {
            measurement = nil
        }
        return OptionalMeasurementProperty<Unit>(
            displayName: displayName,
            value: measurement,
            formatter: formatter,
            formattedValue: formattedValue,
            date: date
        )
    }

}
