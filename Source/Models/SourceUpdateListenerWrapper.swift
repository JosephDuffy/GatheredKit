
internal final class SourceUpdateListenerWrapper {

    internal let updateListener: Source.UpdateListener

    internal init(updateListener: @escaping Source.UpdateListener) {
        self.updateListener = updateListener
    }

}
