import Foundation

open class OptionalProperty<Value, Formatter: Foundation.Formatter>: Property<Value?, Formatter> {
    
    public override var valueAsAny: Any? {
        // This override is required to give the compiler more information, allowing
        // code such as `assert(OptionalProperty(..., value: nil).valueAsAny == nil)`
        // to pass
        return value
    }
    
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

