import Foundation

public struct AnySourceProperty: SourceProperty {

    /// A user-friendly name for the property
    public var displayName: String {
        return box.displayName
    }

    /// The value of the property
    public var value: AnyEquatable {
        return box.value
    }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    public var formattedValue: String?  {
        return box.formattedValue
    }

    /// The unit the value is measured in
    public var unit: SourcePropertyUnit?  {
        return box.unit
    }

    /// The date that the value was created
    public var date: Date {
        return box.date
    }

    private let box: _AnySourcePropertyBase

    internal init<Concrete: SourceProperty>(_ concrete: Concrete) {
        box = _AnySourcePropertyBox(concrete)
    }
}

extension SourceProperty {

    func any() -> AnySourceProperty {
        return AnySourceProperty(self)
    }

}

private class _AnySourcePropertyBase: SourceProperty {

    static func ==(lhs: _AnySourcePropertyBase, rhs: _AnySourcePropertyBase) -> Bool {
        fatalError("Must overide")
    }


    /// A user-friendly name for the property
    var displayName: String {
        fatalError("Must overide")
    }

    /// The value of the property
    var value: AnyEquatable {
        fatalError("Must overide")
    }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    var formattedValue: String?  {
        fatalError("Must overide")
    }

    /// The unit the value is measured in
    var unit: SourcePropertyUnit?  {
        fatalError("Must overide")
    }

    /// The date that the value was created
    var date: Date {
        fatalError("Must overide")
    }

    init() {
        guard type(of: self) != _AnySourcePropertyBase.self else {
            fatalError("_AnySourcePropertyBase must be subclassed")
        }
    }

}

private final class _AnySourcePropertyBox<Concrete: SourceProperty>: _AnySourcePropertyBase {

    /// A user-friendly name for the property
    override var displayName: String {
        return concrete.displayName
    }

    /// The value of the property
    override var value: AnyEquatable {
        return AnyEquatable(concrete.value)
    }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    override var formattedValue: String?  {
        return concrete.formattedValue
    }

    /// The unit the value is measured in
    override var unit: SourcePropertyUnit?  {
        return concrete.unit
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
