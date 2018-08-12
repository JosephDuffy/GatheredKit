
public protocol Value {

    /// A user-friendly name that represents the value, e.g. "Latitude", "Longitude"
    var displayName: String { get }

    /// The value powering this `Value`
    var untypedBackingValue: Any { get }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    var formattedValue: String? { get }

    /// The date that the value was created
    /// If a system-provided date is available it is used
    var date: Date { get }

}

public protocol TypedValue: Value {

    associatedtype ValueType

    /// The value powering this `Value`
    var backingValue: ValueType { get }

}

public protocol UnitProvider {

    var untypedUnit: Unit { get }

}

public protocol TypedUnitProvider: UnitProvider {

    associatedtype UnitType: Unit

    /// The unit the value is measured in
    var unit: UnitType { get }
}

extension TypedUnitProvider {

    public var untypedUnit: Unit {
        return unit
    }

}

public extension TypedValue {

    var untypedBackingValue: Any {
        return backingValue
    }

}

public extension TypedValue where ValueType: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.backingValue == rhs.backingValue
    }

}
