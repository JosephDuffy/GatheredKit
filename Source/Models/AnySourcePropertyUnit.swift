import Foundation

public struct AnySourcePropertyUnit: SourcePropertyUnit {

    private let box: _AnySourcePropertyUnitBase

    internal init<Concrete: SourcePropertyUnit>(_ concrete: Concrete) {
        box = _AnySourcePropertyUnitBox(concrete)
    }

    public func formattedString(for value: Any) throws -> String {
        return try box.formattedString(for: value)
    }
}

private class _AnySourcePropertyUnitBase: SourcePropertyUnit {

    init() {
        guard type(of: self) != _AnySourcePropertyUnitBase.self else {
            fatalError("_AnySourcePropertyUnitBase must be subclassed")
        }
    }

    func formattedString(for value: Any) throws -> String {
        fatalError("Must overide")
    }

}

private final class _AnySourcePropertyUnitBox<Concrete: SourcePropertyUnit>: _AnySourcePropertyUnitBase {

    private let concrete: Concrete

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }

    override func formattedString(for value: Any) throws -> String {
        guard let castValue = value as? Concrete.ValueType else {
            throw SourcePropertyUnitError.unsupportedType(type: type(of: value))
        }

        return try concrete.formattedString(for: castValue)
    }

}
