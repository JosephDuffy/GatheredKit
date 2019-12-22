public enum ControllableSourceError: Error {
    /// Source availability is `restricted`
    case restricted

    /// Source availability is `permissionDenied`
    case permissionDenied

    case other(Error)
}
