public enum AnySourceProviderEvent {
    case startedUpdating
    case stoppedUpdating(error: Error?)
    case sourceAdded(Source)
    case sourceRemoved(Source)
}
