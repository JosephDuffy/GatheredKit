import Foundation

public struct AnyUnit: Unit {

    public var backingUnit: Any {
        return box.backingUnit
    }

    private let box: _AnyUnitBase

    public init<Concrete: Unit>(_ concrete: Concrete) {
        box = _AnyUnitBox(concrete)
    }

    public func formattedString(for value: Any) throws -> String {
        if let backingValue = (value as? AnyValue)?.backingValue {
            return try box.formattedString(for: backingValue)
        } else {
            return try box.formattedString(for: value)
        }
    }

    public func formattedString(for value: Any?) throws -> String {
        if let value = value {
            return try formattedString(for: value)
        } else {
            return "nil"
        }
    }

}

public extension Unit {

    func asAny() -> AnyUnit {
        return AnyUnit(self)
    }

}

private class _AnyUnitBase: Unit {

    var backingUnit: Any {
        fatalError("Must override")
    }

    init() {
        guard type(of: self) != _AnyUnitBase.self else {
            fatalError("_AnyUnitBase must be subclassed")
        }
    }

    func formattedString(for value: Any) throws -> String {
        fatalError("Must overide")
    }

}

private final class _AnyUnitBox<Concrete: Unit>: _AnyUnitBase {

    override var backingUnit: Any {
        return concrete
    }

    private let concrete: Concrete

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }

    override func formattedString(for value: Any) throws -> String {
        guard let castValue = value as? Concrete.ValueType else {
            throw UnitError.unsupportedType(type: type(of: value))
        }

        return try concrete.formattedString(for: castValue)
    }

}
