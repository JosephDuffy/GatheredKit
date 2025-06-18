import Foundation

@attached(member, names: arbitrary)
public macro UpdatableProperty<Value>() = #externalMacro(
    module: "GatheredKitMacrosMacros",
    type: "UpdatableProperty"
)

/// Marks a property as a value of the parent ``UpdatableProperty()``.
///
/// This value includes a unit of measurement.
@attached(accessor)
public macro PropertyValue<Root, Unit: Foundation.Unit>(
    _ property: KeyPath<Root, Double>,
    unit: Unit
) = #externalMacro(module: "GatheredKitMacrosMacros", type: "PropertyValueMeasurement")
