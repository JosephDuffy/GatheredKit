import Foundation

public class MeasurementProperty<Unit: Foundation.Unit>: Property<Measurement<Unit>, MeasurementFormatter> {
    
    public var measurement: Measurement<Unit> {
        return value
    }
    
    public var unit: Unit {
        return value.unit
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
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        let measurement = Measurement(value: value, unit: self.measurement.unit)
        self.update(value: measurement, formattedValue: formattedValue, date: date)
    }
    
}

public class OptionalMeasurementProperty<Unit: Foundation.Dimension>: OptionalProperty<Measurement<Unit>, MeasurementFormatter> {
    
    public var measurement: Measurement<Unit>? {
        return value
    }
    
    public let unit: Unit
    
    public required init(
        displayName: String,
        value: Double?,
        unit: Unit = .baseUnit(),
        formatter: MeasurementFormatter = MeasurementFormatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        self.unit = unit
        let measurement: Measurement<Unit>?
        if let value = value {
            measurement = Measurement<Unit>(value: value, unit: unit)
        } else {
            measurement = nil
        }
        super.init(displayName: displayName, value: measurement, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
    public required init(displayName: String, value measurement: Measurement<Unit>? = nil, formatter: MeasurementFormatter = MeasurementFormatter(), formattedValue: String? = nil, date: Date = Date()) {
        unit = measurement?.unit ?? .baseUnit()
        super.init(displayName: displayName, value: measurement, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
    public func update(
        value: Double,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        update(value: Measurement(value: value, unit: unit), formattedValue: formattedValue, date: date)
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
