public enum SourceAvailability {

    /// The source is available for use
    case available

    /// The source requires the user's permission to run, but has
    /// not yet asked the user for permission.
    ///
    /// The user will be prompted for permissions when the `startUpdating`
    /// function is called.
    case requiresPermissionsPrompt

    /// This app is not authorized to use this source
    ///
    /// The user cannot change this app’s status, possibly due to active
    /// restrictions such as parental controls being in place.
    case restricted

    /// The user has denied permission to access the source
    case permissionDenied

    /// The device does not support this source
    case unavailable

}
