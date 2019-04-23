import Foundation

open class OptionalValue<ValueType, Formatter: Foundation.Formatter>: Value<ValueType?, Formatter> {
    
    public override var backingValueAsAny: Any? {
        // This override is required to give the compiler more information, allowing
        // code such as `assert(OptionalValue(..., backingValue: nil).backingValueAsAny == nil)`
        // to pass
        return backingValue
    }
    
    public required init(
        displayName: String,
        backingValue: ValueType? = nil,
        formatter: Formatter = Formatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        super.init(displayName: displayName, backingValue: backingValue, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
}

