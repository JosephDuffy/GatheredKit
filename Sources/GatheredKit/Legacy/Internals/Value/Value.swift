public protocol AnyValue {

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

//extension Value where Self: UnitProvider {
//    public var formattedValue: String {
//        return (try? untypedUnit.formattedString(for: untypedBackingValue)) ?? String(describing: untypedBackingValue)
//    }
//}

public protocol TypedValue: AnyValue {

    associatedtype ValueType

    /// The value powering this `Value`
    var backingValue: ValueType { get }

}

public protocol UnitProvider {

    var unit: Unit { get }

}

public protocol TypedUnitProvider {

    associatedtype UnitType: TypedUnit

    /// The unit the value is measured in
    var unit: UnitType { get }
}

extension UnitProvider where Self: TypedUnitProvider { }

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

    static func == (lhs: Self, rhs: ValueType) -> Bool {
        return lhs.backingValue == rhs
    }

    static func == (lhs: ValueType, rhs: Self) -> Bool {
        return lhs == rhs.backingValue
    }

}

//public struct NewValue<RawValue> {
//
//    public let displayName: String
//
//    public let rawValue: RawValue
//
//    public init(displayName: String, rawValue: RawValue) {
//        self.displayName = displayName
//        self.rawValue = rawValue
//    }
//
//}
//
//extension NewValue: Codable where RawValue: Codable { }
//
//public struct ValueSnapshot<Value: TypedValue, UnitType: NewUnit> where Value.ValueType == UnitType.RawValue {
//
//    public private(set) var value: Value
//
//    public let unit: UnitType
//
//    public private(set) var timestamp: Date
//
//    public var formattedValue: String {
//        return unit.formattedString(for: value.backingValue)
//    }
//
//    public mutating func updateValue(_ value: Value, timestamp: Date = Date()) {
//        self.value = value
//        self.timestamp = timestamp
//    }
//
//}
//
//extension ValueSnapshot: Codable where RawValue: Codable { }
//
//public typealias AnyNewValue = NewValue<Any>
//
//extension NewValue {
//
//    public func toAny() -> AnyNewValue {
//        return NewValue<Any>(displayName: displayName, rawValue: rawValue)
//    }
//
//}
//
//public protocol NewUnit: Codable {
//
//    associatedtype RawValue
//
//    func formattedString(for value: RawValue) -> String
//
//}
//
//public protocol ValueProvider {
//
//    var displayName: String { get }
//
//    var value: Value { get }
//
//    var date: Date { get }
//
//}
