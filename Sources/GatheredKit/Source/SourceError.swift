public enum SourceError: Error, Codable, Hashable {
    /// Source availability is `restricted`
    case restricted

    /// Source availability is `permissionDenied`
    case permissionDenied

    /// Source is unavailable.
    case unavailable
}
