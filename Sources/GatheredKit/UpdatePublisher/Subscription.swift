public final class Subscription {

    internal typealias CancelHandler = () -> Void

    private var cancelHandler: CancelHandler?

    internal init(cancel cancelHandler: @escaping CancelHandler) {
        self.cancelHandler = cancelHandler
    }

    deinit {
        cancel()
    }

    public func cancel() {
        guard let cancelHandler = cancelHandler else { return }
        cancelHandler()
        self.cancelHandler = nil
    }
}
