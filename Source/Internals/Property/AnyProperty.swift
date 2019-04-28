import Foundation

public protocol AnyProperty: Snapshot & AnyProducer {
    var displayName: String { get }
}

internal protocol FormatterProvider {
    var formatterAsFoundationFormatter: Formatter { get }
}

extension AnyProperty {    
    var formatter: Formatter {
        guard let self = self as? FormatterProvider else {
            assertionFailure("The `value` property on `AnyProperty` relies on self conforming to `FormatterProvider`")
            return Formatter()
        }
        return self.formatterAsFoundationFormatter
    }

}
