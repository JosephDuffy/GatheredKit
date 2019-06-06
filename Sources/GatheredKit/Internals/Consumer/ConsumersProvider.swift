internal protocol ConsumersProvider: class {
    var consumers: [AnyConsumer] { get set }
}

extension ConsumersProvider  {
    internal func notifyUpdateConsumers(of properties: [Any]) {
        consumers.forEach { $0.consume(properties, self) }
    }
}

extension PropertiesProvider where Self: ConsumersProvider  {
    internal func notifyUpdateConsumersOfLatestValues() {
        notifyUpdateConsumers(of: allProperties)
    }
}
