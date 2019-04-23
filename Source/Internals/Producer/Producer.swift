public protocol Producer: AnyProducer {
    associatedtype ProducedValue
    
    func add<Consumer: GatheredKit.Consumer>(consumer: Consumer) where Consumer.ConsumedValue == ProducedValue, Consumer.ConsumedSender == Self
}

extension Producer {
    public func add<Consumer: GatheredKit.Consumer>(consumer: Consumer) where Consumer.ConsumedValue == ProducedValue, Consumer.ConsumedSender == Self {
        self.add(consumer: consumer as AnyConsumer)
    }
}
