import Foundation

@attached(member, names: arbitrary)
public macro UpdatableProperty<Value>() = #externalMacro(
    module: "GatheredKitMacrosMacros",
    type: "UpdatableProperty"
)

/// Marks a property as a child property of the parent ``UpdatableProperty()``.
///
/// This property includes a unit of measurement
@attached(accessor)
public macro ChildProperty<Root, Unit: Foundation.Unit>(
    _ property: KeyPath<Root, Double>,
    unit: Unit
) = #externalMacro(module: "GatheredKitMacrosMacros", type: "ChildPropertyMeasurement")
