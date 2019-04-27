internal final class WeakConsumerWrapper: AnyConsumer {
    private weak var consumer: AnyConsumer?
    
    internal init(consumer: AnyConsumer) {
        self.consumer = consumer
    }
    
    func consume(_ value: Any, _ sender: Any) {
        consumer?.consume(value, sender)
    }
}
