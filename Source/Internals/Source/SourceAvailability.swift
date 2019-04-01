public enum SourceAvailability {

    /// The source is available for use
    case available

    /// The source requires the user's permission to run, but has
    /// not yet asked the user for permission.
    /// The user will be prompted for permissions when the `startUpdating`
    /// function is called.
    case requiresPermissionsPrompt

    /// The user has denied permission to access the source
    case restricted

    /// The user has denied permission to access the source
    case permissionDenied

    /// The device does not support this source
    case unavailable

}
