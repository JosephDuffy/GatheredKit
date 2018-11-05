import Foundation

public struct GenericValue<ValueType, UnitType: Unit>: TypedValue, TypedUnitProvider {

    public typealias UpdateListener = (_ sourceProperty: GenericValue<ValueType,
    UnitType>) -> Void

    /// A user-friendly name that represents the value, e.g. "Latitude", "Longitude"
    public let displayName: String

    /// The value powering this `GenericValue`
    public let backingValue: ValueType

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    public let formattedValue: String?

    /// The unit the value is measured in
    public let unit: UnitType

    /// The date that the value was created
    /// If a system-provided date is available it is used
    public let date: Date

    internal init(
        displayName: String,
        backingValue: ValueType,
        formattedValue: String? = nil,
        unit: UnitType,
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.backingValue = backingValue
        self.formattedValue = formattedValue
        self.unit = unit
        self.date = date
    }

    internal init<WrappedValueType>(
        displayName: String,
        backingValue: WrappedValueType? = nil,
        formattedValue: String? = nil,
        unit: UnitType,
        date: Date = Date()
    ) where ValueType == WrappedValueType? {
        self.displayName = displayName
        self.backingValue = backingValue
        self.formattedValue = formattedValue
        self.unit = unit
        self.date = date
    }

    /**
     Updates the data backing this `SourceProperty`
     - parameter backingValue: The new value of the data
     - parameter formattedValue: The new human-friendly formatted value. Defaults to `nil`
     - parameter date: The date and time the `value` was recorded. Defaults to the current date and time
     */
    public mutating func update(
        backingValue: ValueType,
        formattedValue: String? = nil,
        date: Date = Date()
    ) {
        self = GenericValue(
            displayName: displayName,
            backingValue: backingValue,
            formattedValue: formattedValue,
            unit: unit,
            date: date
        )
    }

}

extension GenericValue where UnitType: ZeroConfigurationUnit {

    internal init(
        displayName: String,
        backingValue: ValueType,
        formattedValue: String? = nil,
        unit: UnitType = UnitType(),
        date: Date = Date()
    ) {
        self.displayName = displayName
        self.backingValue = backingValue
        self.formattedValue = formattedValue
        self.unit = unit
        self.date = date
    }

    internal init<WrappedValueType>(
        displayName: String,
        backingValue: WrappedValueType? = nil,
        formattedValue: String? = nil,
        unit: UnitType = UnitType(),
        date: Date = Date()
    ) where ValueType == WrappedValueType? {
        self.displayName = displayName
        self.backingValue = backingValue
        self.formattedValue = formattedValue
        self.unit = unit
        self.date = date
    }

}

extension GenericValue: ValuesProvider where ValueType: ValuesProvider {

    public var allValues: [Value] {
        return backingValue.allValues
    }

}

extension GenericValue: Codable where ValueType: Codable, UnitType: Codable { }
