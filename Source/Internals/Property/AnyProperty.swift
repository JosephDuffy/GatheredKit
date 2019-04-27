import Foundation

public protocol AnyProperty: AnyProducer {
    var displayName: String { get }
    var date: Date { get }
    var formattedValue: String? { get }
}

internal protocol ValueProvider {
    var valueAsAny: Any? { get }
}

internal protocol FormatterProvider {
    var formatterAsFoundationFormatter: Formatter { get }
}

extension AnyProperty {

    var value: Any? {
        guard let self = self as? ValueProvider else {
            assertionFailure("The `value` property on `AnyProperty` relies on self conforming to `ValueProvider`")
            return nil
        }
        return self.valueAsAny
    }
    
    var formatter: Formatter {
        guard let self = self as? FormatterProvider else {
            assertionFailure("The `value` property on `AnyProperty` relies on self conforming to `FormatterProvider`")
            return Formatter()
        }
        return self.formatterAsFoundationFormatter
    }

}
