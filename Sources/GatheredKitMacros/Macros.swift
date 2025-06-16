import Foundation

@attached(member, names: arbitrary)
public macro UpdatableProperty<Value>() = #externalMacro(
    module: "GatheredKitMacrosMacros",
    type: "UpdatableProperty"
)

@attached(peer)
public macro ChildProperty<Root, Value>(
    _ property: KeyPath<Root, Value>,
    unit: UnitAngle
) = #externalMacro(module: "GatheredKitMacrosMacros", type: "ChildPropertyMeasurement")
