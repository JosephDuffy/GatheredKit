import Foundation
import GatheredKit

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
