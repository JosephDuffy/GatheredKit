public protocol UpdateConsumersProvider: class {
    var updateConsumers: [UpdatesConsumer] { get set }
    func add(updatesConsumer: UpdatesConsumer)
    func remove(updatesConsumer: UpdatesConsumer)
}

extension UpdateConsumersProvider {
    public func add(updatesConsumer: UpdatesConsumer) {
        updateConsumers.append(updatesConsumer)
    }
    
    public func remove(updatesConsumer: UpdatesConsumer) {
        updateConsumers.removeAll(where: { $0 === updatesConsumer })
    }
}

extension UpdateConsumersProvider where Self: Source {
    public func addUpdateListener(
        _ updateListener: @escaping ClosureUpdatesConsumer.UpdatesClosure,
        queue: OperationQueue
    ) -> ClosureUpdatesConsumer {
        let consumer = ClosureUpdatesConsumer(queue: queue) { [weak self] values, _ in
            guard let self = self else { return }
            updateListener(values, self)
        }
        add(updatesConsumer: consumer)
        return consumer
    }
    
    internal func notifyUpdateConsumers(of newValues: [AnyValue]) {
        updateConsumers.forEach { $0.comsume(values: newValues, sender: self) }
    }
}

extension UpdateConsumersProvider where Self: Source & ValuesProvider {
    internal func notifyUpdateConsumersOfLatestValues() {
        updateConsumers.forEach { $0.comsume(values: allValues, sender: self) }
    }
}
