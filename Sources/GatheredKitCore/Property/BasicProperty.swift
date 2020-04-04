import Foundation

@available(*, deprecated, renamed: "BasicProperty")
public typealias BasicPropertyPropertyWrapper = BasicProperty

public typealias BasicProperty<Value, Formatter: Foundation.Formatter> = Property<Value, Formatter, ReadOnlyProperty<Value, Formatter>>
