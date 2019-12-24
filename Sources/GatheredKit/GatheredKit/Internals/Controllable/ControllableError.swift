public enum ControllableError: Error {
    
    /// Availability is `restricted`
    case restricted

    /// Availability is `permissionDenied`
    case permissionDenied
    
    case unknownPermission

    case other(Error)
}
