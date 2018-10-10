public final class SourceUpdateListenerWrapper {

    internal let updateListener: Source.UpdateListener

    internal let queue: DispatchQueue

    internal init(
        updateListener: @escaping Source.UpdateListener,
        queue: DispatchQueue
    ) {
        self.updateListener = updateListener
        self.queue = queue
    }

}
