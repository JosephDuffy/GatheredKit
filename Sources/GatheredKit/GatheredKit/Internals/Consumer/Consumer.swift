public protocol Consumer: AnyConsumer {
    associatedtype ConsumedValue
    associatedtype ConsumedSender
    
    func consume(value: ConsumedValue, sender: ConsumedSender)
}

extension Consumer {
    
    public func consume(_ value: Any, _ sender: Any) {
        guard let value = value as? ConsumedValue else { return }
        guard let sender = sender as? ConsumedSender else { return }
        consume(value: value, sender: sender)
    }
    
}
