
public final class SourceUpdateListenerWrapper {

    internal let updateListener: ControllableSource.UpdateListener

    internal let queue: DispatchQueue

    internal init(updateListener: @escaping ControllableSource.UpdateListener, queue: DispatchQueue) {
        self.updateListener = updateListener
        self.queue = queue
    }

}
