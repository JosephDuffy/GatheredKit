public protocol AnyProducer: class {
    func add(consumer: AnyConsumer)
}

extension AnyProducer {
    public func add(consumer: AnyConsumer) {
        guard let self = self as? ConsumersProvider else {
            assertionFailure(#function + " must be implemented")
            return
        }
        self.consumers.append(WeakConsumerWrapper(consumer: consumer))
    }
}
