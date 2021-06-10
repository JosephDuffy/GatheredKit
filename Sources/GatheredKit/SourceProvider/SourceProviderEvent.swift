public enum SourceProviderEvent<Source: GatheredKit.Source> {
    case startedUpdating
    case stoppedUpdating(error: Error? = nil)
    case sourceAdded(Source)
    case sourceRemoved(Source)
}
