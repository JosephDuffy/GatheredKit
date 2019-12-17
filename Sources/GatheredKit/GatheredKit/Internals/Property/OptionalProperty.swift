import Foundation

open class OptionalProperty<UnwrappedValue, Formatter: Foundation.Formatter>: Property<UnwrappedValue?, Formatter> {
    
    public required init(
        displayName: String,
        value: UnwrappedValue? = nil,
        formatter: Formatter = Formatter(),
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        super.init(displayName: displayName, value: value, formatter: formatter, formattedValue: formattedValue, date: date)
    }
    
}

