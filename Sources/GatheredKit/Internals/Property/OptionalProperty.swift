import Foundation

open class OptionalProperty<Value, Formatter: Foundation.Formatter>: Property<Value?, Formatter> {
    
    public required init(
        displayName: String,
        value: Value? = nil,
        formatter: Formatter = Formatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        super.init(displayName: displayName, value: value, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
}

