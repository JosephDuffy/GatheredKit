public enum ControllableEvent {
    case propertyUpdated(property: AnyProperty, snapshot: AnySnapshot)
    case failedToStart(error: SourceError)
    case startedUpdating
    case stoppedUpdating(error: Error? = nil)
    case requestingPermission
    case availabilityUpdated(SourceAvailability)
}
