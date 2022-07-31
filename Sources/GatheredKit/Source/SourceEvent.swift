public enum SourceEvent {
    case failedToStart(error: SourceError)
    case startedUpdating
    case stoppedUpdating(error: Error? = nil)
    case requestingPermission
    case availabilityUpdated(SourceAvailability)
}
