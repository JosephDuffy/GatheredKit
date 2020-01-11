public enum ControllableEvent {
    case startedUpdating
    case stoppedUpdating
    case requestingPermission
    case availabilityUpdated(SourceAvailability)
}
