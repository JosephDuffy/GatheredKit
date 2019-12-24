public enum SourceProviderEvent<Source: GatheredKit.Source> {
    case sourceAdded(Source)
    case sourceRemoved(Source)
}
