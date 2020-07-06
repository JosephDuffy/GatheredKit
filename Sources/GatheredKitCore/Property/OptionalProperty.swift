import Foundation

public typealias OptionalProperty<UnwrappedValue, Formatter: Foundation.Formatter> = BasicProperty<
    UnwrappedValue?, Formatter
>
