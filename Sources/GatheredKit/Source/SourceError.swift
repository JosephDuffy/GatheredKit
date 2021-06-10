public enum SourceError: Error {
    /// Source availability is `restricted`
    case restricted

    /// Source availability is `permissionDenied`
    case permissionDenied

    case unavailable

    case other(Error)
}
