public final class ClosureConsumer<ConsumedValue, ConsumedSender>: Consumer {
    
    public typealias UpdatesClosure = (_ value: ConsumedValue, _ sender: ConsumedSender) -> Void
    
    private let queue: OperationQueue
    private let closure: UpdatesClosure
    
    public init(queue: OperationQueue = .main, closure: @escaping UpdatesClosure) {
        self.queue = queue
        self.closure = closure
    }
    
    public func consume(value: ConsumedValue, sender: ConsumedSender) {
        queue.addOperation { [closure] in
            closure(value, sender)
        }
    }
    
}

extension Producer {
    func consumeUpdates(
        sendingUpdatesOn queue: OperationQueue = .main,
        to updateListener: @escaping ClosureConsumer<ProducedValue, Self>.UpdatesClosure
    ) -> ClosureConsumer<ProducedValue, Self> {
        let consumer = ClosureConsumer(queue: queue, closure: updateListener)
        add(consumer: consumer)
        return consumer
    }
}
