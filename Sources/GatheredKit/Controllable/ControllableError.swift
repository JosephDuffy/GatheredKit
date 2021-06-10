public enum ControllableError: Error {

    /// Availability is `restricted`
    case restricted

    /// Availability is `permissionDenied`
    case permissionDenied

    /// Availability is `Unavailable`
    case unavailable

    case unknownPermission

    case other(Error)
}
