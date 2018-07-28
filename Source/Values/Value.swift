
public protocol Value {

    associatedtype ValueType

    associatedtype UnitType: Unit

    /// A user-friendly name that represents the value, e.g. "Latitude", "Longitude"
    var displayName: String { get }

    /// The value powering this `Value`
    var backingValue: ValueType { get }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    var formattedValue: String? { get }

    /// The unit the value is measured in
    var unit: UnitType { get }

    /// The date that the value was created
    /// If a system-provided date is available it is used
    var date: Date { get }

}

public extension Value where ValueType: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.backingValue == rhs.backingValue
    }

}
