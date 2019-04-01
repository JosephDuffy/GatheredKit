//public protocol AnyValue {
//
//    /// A user-friendly name that represents the value, e.g. "Latitude", "Longitude"
////    var displayName: String { get }
//
//    /// The value powering this `Value`
//    var backingValueAsAny: Any { get }
//
//    /// A human-friendly formatted value
//    /// Note that this may differ from the result of `unit.formattedString(for:)`
////    var formattedValue: String? { get }
//
//    /// The date that the value was created
//    /// If a system-provided date is available it is used
////    var date: Date { get }
//
//}
//
//extension AnyValue where Self: AnyUnitProvider {
//    public var formattedValue: String {
//        return (try? unit.formattedString(for: backingValueAsAny)) ?? String(describing: backingValueAsAny)
//    }
//}
//
//public protocol Value: AnyValue {
//
//    associatedtype ValueType
//
//    /// The value powering this `Value`
//    var backingValue: ValueType { get }
//
//}

//public protocol AnyUnitProvider {
//
//    var unit: AnyUnit { get }
//
//}
//
//public protocol UnitProvider {
//
//    associatedtype UnitType: Unit
//
//    /// The unit the value is measured in
//    var unit: UnitType { get }
//}
//
//extension AnyUnitProvider where Self: UnitProvider { }
//
//extension UnitProvider {
//
//    public var untypedUnit: AnyUnit {
//        return unit
//    }
//
//}

//public extension Value {
//
//    var backingValueAsAny: Any {
//        return backingValue
//    }
//
//}
//
//public extension Value where ValueType: Equatable {
//
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        return lhs.backingValue == rhs.backingValue
//    }
//
//    static func == (lhs: Self, rhs: ValueType) -> Bool {
//        return lhs.backingValue == rhs
//    }
//
//    static func == (lhs: ValueType, rhs: Self) -> Bool {
//        return lhs == rhs.backingValue
//    }
//
//}

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
//public struct ValueSnapshot<ValueType: Value, UnitType: Unit> where ValueType.ValueType == UnitType.ValueType {
//
//    public let displayName: String
//
//    public private(set) var value: ValueType
//
//    public let unit: UnitType
//
//    public private(set) var timestamp: Date
//
//    public var formattedValue: String {
//        return unit.formattedString(for: value.backingValue)
//    }
//
//    public mutating func updateValue(_ value: ValueType, timestamp: Date = Date()) {
//        self.value = value
//        self.timestamp = timestamp
//    }
//
//}


//extension ValueSnapshot: Codable where ValueType: Codable { }
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
