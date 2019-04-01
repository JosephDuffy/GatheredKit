public final class ClosureUpdatesConsumer: UpdatesConsumer {
    
    public typealias UpdatesClosure = ([AnyValue], Source) -> Void
    
    private let closure: UpdatesClosure
    
    public init(queue: OperationQueue = .main, closure: @escaping UpdatesClosure) {
        self.closure = closure
    }
    
    public func comsume(values: [AnyValue], from source: Source) {
        closure(values, source)
    }
    
}
