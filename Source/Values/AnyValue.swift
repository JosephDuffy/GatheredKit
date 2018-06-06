import Foundation

public struct AnyValue: Value {

    public static func == (lhs: AnyValue, rhs: AnyValue) -> Bool {
        return lhs.box == rhs.box
    }

    /// A user-friendly name for the property
    public var displayName: String {
        return box.displayName
    }

    /// The value backing this `AnyValue`
    public var backingValue: Any {
        return box.backingValue
    }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    public var formattedValue: String?  {
        return box.formattedValue
    }

    /// The unit the value is measured in
    public var unit: AnyUnit {
        return box.unit
    }

    /// The date that the value was created
    public var date: Date {
        return box.date
    }

    private let box: _AnyValueBase

    internal init<Concrete: Value>(_ concrete: Concrete) {
        box = _AnyValueBox(concrete)
    }
}

extension Value {

    func asAny() -> AnyValue {
        return AnyValue(self)
    }

}

private class _AnyValueBase: Value {

    static func ==(lhs: _AnyValueBase, rhs: _AnyValueBase) -> Bool {
        fatalError("Must overide")
    }

    /// A user-friendly name for the property
    var displayName: String {
        fatalError("Must overide")
    }

    /// The value of the property
    var backingValue: Any {
        fatalError("Must overide")
    }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    var formattedValue: String?  {
        fatalError("Must overide")
    }

    /// The unit the value is measured in
    var unit: AnyUnit {
        fatalError("Must overide")
    }

    /// The date that the value was created
    var date: Date {
        fatalError("Must overide")
    }

    init() {
        guard type(of: self) != _AnyValueBase.self else {
            fatalError("_AnyValueBase must be subclassed")
        }
    }

}

private final class _AnyValueBox<Concrete: Value>: _AnyValueBase {

    static func ==(lhs: _AnyValueBox<Concrete>, rhs: _AnyValueBox<Concrete>) -> Bool {
        return lhs.concrete == rhs.concrete
    }

    /// A user-friendly name for the property
    override var displayName: String {
        return concrete.displayName
    }

    /// The value of the property
    override var backingValue: Any {
        return concrete.backingValue
    }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    override var formattedValue: String?  {
        return concrete.formattedValue
    }

    /// The unit the value is measured in
    override var unit: AnyUnit  {
        return AnyUnit(concrete.unit)
    }

    /// The date that the value was created
    override var date: Date {
        return concrete.date
    }

    private let concrete: Concrete

    init(_ concrete: Concrete) {
        self.concrete = concrete
    }

}
