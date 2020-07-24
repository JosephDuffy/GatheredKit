public enum SourceProviderEvent<Source: GatheredKitCore.Source> {
    case startedUpdating
    case stoppedUpdating(error: Error? = nil)
    case sourceAdded(Source)
    case sourceRemoved(Source)
}
