
public protocol SourceProperty: Equatable {

    associatedtype ValueType

    /// A user-friendly name for the property
    var displayName: String { get }

    /// The value of the property
    var value: ValueType { get }

    /// A human-friendly formatted value
    /// Note that this may differ from the result of `unit.formattedString(for:)`
    var formattedValue: String?  { get }

    /// The unit the value is measured in
    var unit: SourcePropertyUnit?  { get }

    /// The date that the value was created
    var date: Date { get }

}
