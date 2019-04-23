public protocol AnyConsumer: class {
    func consume(_ value: Any, _ sender: Any)
}
