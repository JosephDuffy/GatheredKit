public enum SourceEvent {
    case propertyUpdated(property: AnyProperty, snapshot: AnySnapshot)
    case startedUpdating
    case stoppedUpdating
    case requestingPermission
}
