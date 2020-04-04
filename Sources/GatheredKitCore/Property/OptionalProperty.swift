import Foundation

@available(*, deprecated, renamed: "OptionalProperty")
public typealias OptionalPropertyPropertyWrapper = OptionalProperty

public typealias OptionalProperty<UnwrappedValue, Formatter: Foundation.Formatter, ReadOnlyProperty> = Property<UnwrappedValue?, Formatter, ReadOnlyProperty> where ReadOnlyProperty: GatheredKitCore.ReadOnlyProperty<UnwrappedValue?, Formatter>
