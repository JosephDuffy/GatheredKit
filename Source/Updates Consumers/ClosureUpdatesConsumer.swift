public final class ClosureUpdatesConsumer: UpdatesConsumer {
    
    public typealias UpdatesClosure = ([AnyValue], AnyObject) -> Void
    
    private let queue: OperationQueue
    private let closure: UpdatesClosure
    
    public init(queue: OperationQueue = .main, closure: @escaping UpdatesClosure) {
        self.queue = queue
        self.closure = closure
    }
    
    public func comsume(values: [AnyValue], sender: AnyObject) {
        queue.addOperation { [closure] in
            closure(values, sender)
        }
    }
    
}
