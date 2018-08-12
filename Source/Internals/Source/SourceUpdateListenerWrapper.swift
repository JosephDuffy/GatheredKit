
public final class SourceUpdateListenerWrapper {

    internal let updateListener: Controllable.UpdateListener

    internal let queue: DispatchQueue

    internal init(updateListener: @escaping Controllable.UpdateListener, queue: DispatchQueue) {
        self.updateListener = updateListener
        self.queue = queue
    }

}
