import Foundation

public struct GenericUnitlessValue<ValueType>: TypedValue {

    public typealias UpdateListener = (_ sourceProperty: GenericUnitlessValue<ValueType>) -> Void

    /// A user-friendly name that represents the value, e.g. "Latitude", "Longitude"
    public let displayName: String

    /// The value backing this `GenericUnitlessValue`
    public let backingValue: ValueType

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    public let formattedValue: String?

    /// The date that the value was created
    /// If a system-provided date is available it is used
    public let date: Date

    internal init(
        displayName: String,
        backingValue: ValueType,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.backingValue = backingValue
        self.formattedValue = formattedValue
        self.date = date
    }

    internal init<WrappedValueType>(
        displayName: String,
        backingValue: WrappedValueType? = nil,
        formattedValue: String? = nil,
        date: Date = Date()
    ) where ValueType == WrappedValueType? {
        self.displayName = displayName
        self.backingValue = backingValue
        self.formattedValue = formattedValue
        self.date = date
    }

    /**
     Updates the data backing this `SourceProperty`
     - parameter backingValue: The new value of the data
     - parameter formattedValue: The new human-friendly formatted value. Defaults to `nil`
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public mutating func update(backingValue: ValueType, formattedValue: String? = nil, date: Date = Date()) {
        self = GenericUnitlessValue(
            displayName: displayName,
            backingValue: backingValue,
            formattedValue: formattedValue,
            date: date
        )
    }

}

extension GenericUnitlessValue: Equatable where ValueType: Equatable {

    public static func == (lhs: GenericUnitlessValue<ValueType>, rhs: GenericUnitlessValue<ValueType>) -> Bool {
        return lhs.backingValue == rhs.backingValue
    }

}

extension GenericUnitlessValue: ValuesProvider where ValueType: ValuesProvider {

    public var allValues: [Value] {
        return backingValue.allValues
    }

}
