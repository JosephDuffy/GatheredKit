import Foundation

@attached(member, names: arbitrary)
public macro UpdatableProperty<Value>() = #externalMacro(
    module: "GatheredKitMacrosMacros",
    type: "UpdatableProperty"
)

/// Marks a property as a child property of the parent ``UpdatableProperty()``.
///
/// This property includes a unit of measurement
@attached(peer)
public macro ChildProperty<Root, Unit: Foundation.Unit>(
    _ property: KeyPath<Root, Double>,
    unit: Unit,
    formatter: ((_ measurement: Measurement<Unit>) -> String)? = nil
) = #externalMacro(module: "GatheredKitMacrosMacros", type: "ChildPropertyMeasurement")

/// Marks a property as a child property of the parent ``UpdatableProperty()``.
///
/// This property includes a unit of measurement
@attached(peer)
public macro ChildProperty<Root, Unit: Foundation.Dimension>(
    _ property: KeyPath<Root, Double>,
    dimension: Unit,
    formatter: (
        (
            _ measurement: Measurement<Unit>,
            _ formatStyleModifier: ((_ formatStyle: inout Measurement<Unit>.FormatStyle) -> Void)?
        ) -> String
    )? = { measurement, formatStyleModifier in
        var formatStyle = Measurement<Unit>.FormatStyle(width: .abbreviated)
        formatStyleModifier?(&formatStyle)
        return measurement.formatted(formatStyle)
    }
) = #externalMacro(module: "GatheredKitMacrosMacros", type: "ChildPropertyMeasurement")
