public enum SourceProviderEvent<Source: GatheredKitCore.Source> {
    case sourceAdded(Source)
    case sourceRemoved(Source)
}
