internal protocol ConsumersProvider: class {
    var consumers: [AnyConsumer] { get set }
}

extension ValuesProvider where Self: ConsumersProvider  {
    internal func notifyUpdateConsumersOfLatestValues() {
        consumers.forEach { $0.consume(allValues, self) }
    }
}

