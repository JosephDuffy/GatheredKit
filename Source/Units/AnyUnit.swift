import Foundation

public struct AnyUnit: Unit {

    private let box: _AnyUnitBase

    internal init<Concrete: Unit>(_ concrete: Concrete) {
        box = _AnyUnitBox(concrete)
    }

    public func formattedString(for value: Any) throws -> String {
        return try box.formattedString(for: value)
    }
}

private class _AnyUnitBase: Unit {

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
