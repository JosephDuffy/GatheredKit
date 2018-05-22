import Foundation

public struct GenericSourceProperty<ValueType: Equatable & Codable>: SourceProperty {

    public typealias UpdateListener = (_ sourceProperty: GenericSourceProperty<ValueType>) -> Void

    public static func ==(lhs: GenericSourceProperty<ValueType>, rhs: GenericSourceProperty<ValueType>) -> Bool {
        return
            lhs.displayName == rhs.displayName &&
                lhs.value == rhs.value &&
                lhs.formattedValue == rhs.formattedValue &&
                type(of: lhs.unit) == type(of: rhs.unit) &&
                lhs.date == rhs.date
    }

    /// A user-friendly name for the property
    public let displayName: String

    /// The value of the property
    public let value: ValueType

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    public let formattedValue: String?

    /// The unit the value is measured in
    public let unit: SourcePropertyUnit?

    /// The date that the value was created
    public let date: Date

    internal init(
        displayName: String,
        value: ValueType,
        formattedValue: String? = nil,
        unit: SourcePropertyUnit? = nil,
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.value = value
        self.formattedValue = formattedValue
        self.unit = unit
        self.date = date
    }

    /**
     Updates the data backing this `SourceProperty`
     - parameter value: The new value of the data
     - parameter formattedValue: The new human-friendly formatted value. Defaults to `nil`
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public mutating func update(value: ValueType, formattedValue: String? = nil, date: Date = Date()) {
        self = GenericSourceProperty(displayName: displayName, value: value, formattedValue: formattedValue, unit: unit, date: date)
    }

}
