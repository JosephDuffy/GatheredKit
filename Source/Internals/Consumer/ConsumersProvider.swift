internal protocol ConsumersProvider: class {
    var consumers: [AnyConsumer] { get set }
}

extension ConsumersProvider  {
    internal func notifyUpdateConsumers(of values: [Any]) {
        consumers.forEach { $0.consume(values, self) }
    }
}

extension ValuesProvider where Self: ConsumersProvider  {
    internal func notifyUpdateConsumersOfLatestValues() {
        notifyUpdateConsumers(of: allValues)
    }
}
