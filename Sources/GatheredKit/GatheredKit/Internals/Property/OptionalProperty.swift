import Foundation

open class OptionalProperty<UnwrappedValue, Formatter: Foundation.Formatter>: Property<UnwrappedValue?, Formatter> {

    public required init(
        displayName: String,
        value: UnwrappedValue? = nil,
        formatter: Formatter = Formatter(),
        date: Date = Date()
    ) {
        super.init(displayName: displayName, value: value, formatter: formatter, date: date)
    }

}
