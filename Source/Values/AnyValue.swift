import Foundation

public typealias AnyValue = GenericValue<Any, AnyUnit>

public extension Value {

    func asAny() -> AnyValue {
        return AnyValue(displayName: displayName, backingValue: backingValue, formattedValue: formattedValue, unit: AnyUnit(unit), date: date)
    }

}
