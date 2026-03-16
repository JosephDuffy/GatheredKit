import Foundation
import GatheredKit

@attached(member, names: arbitrary)
public macro UpdatableProperty<Value>() = #externalMacro(
    module: "GatheredKitMacrosMacros",
    type: "UpdatableProperty"
)

/// Declares a `SourceKind` static member inside `extension SourceKind`.
///
/// - parameter sourceKind: The source kind to declare. The raw value will match this value.
@freestanding(declaration, names: arbitrary)
public macro SourceKind(_ sourceKind: String) = #externalMacro(
    module: "GatheredKitMacrosMacros",
    type: "SourceKindDeclaration"
)

/// Declares a `SourceKind` static member inside `extension SourceKind`.
///
/// - parameter sourceKind: The source kind to declare.
/// - parameter rawValue: The raw value of the source kind.
@freestanding(declaration, names: arbitrary)
public macro SourceKind(_ sourceKind: String, rawValue: String) = #externalMacro(
    module: "GatheredKitMacrosMacros",
    type: "SourceKindDeclaration"
)

/// Marks a property as a value of the parent ``UpdatableProperty()``.
///
/// This value includes a unit of measurement.
@attached(accessor)
public macro PropertyValue<Root, Unit: Foundation.Unit>(
    _ property: KeyPath<Root, Double>,
    unit: Unit
) = #externalMacro(module: "GatheredKitMacrosMacros", type: "PropertyValueMeasurement")

@attached(accessor)
public macro PropertyValue<Root, Unit: Foundation.Unit>(
    _ property: KeyPath<Root, CGFloat>,
    unit: Unit
) = #externalMacro(module: "GatheredKitMacrosMacros", type: "PropertyValueMeasurement")

/// Marks a property as a value of the parent ``UpdatableProperty()``.
@attached(accessor)
public macro PropertyValue<Root, Value>(
    _ property: KeyPath<Root, Value>
) = #externalMacro(module: "GatheredKitMacrosMacros", type: "PropertyValue")

/// Marks a property as a child property of the parent ``UpdatableProperty()``.
@attached(accessor)
public macro ChildProperty<Root, Value>(
    _ property: KeyPath<Root, Value>,
    propertyType: any Property.Type
) = #externalMacro(module: "GatheredKitMacrosMacros", type: "ChildProperty")
