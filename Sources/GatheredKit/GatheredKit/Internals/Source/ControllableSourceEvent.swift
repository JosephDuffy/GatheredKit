public enum ControllableSourceEvent {
    case propertyUpdated(property: AnyProperty, snapshot: AnySnapshot)
    case startedUpdating
    case stoppedUpdating
    case requestingPermission
}
