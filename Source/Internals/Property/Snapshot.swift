public protocol Snapshot {
    var date: Date { get }
    var formattedValue: String? { get }
}

internal protocol ValueProvider {
    var valueAsAny: Any? { get }
}

extension Snapshot {
    
    var value: Any? {
        guard let self = self as? ValueProvider else {
            assertionFailure("The `value` property on `AnyProperty` relies on self conforming to `ValueProvider`")
            return nil
        }
        return self.valueAsAny
    }
    
}
