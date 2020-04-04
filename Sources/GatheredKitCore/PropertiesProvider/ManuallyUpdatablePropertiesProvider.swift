/**
 A property provider that supports its properties being updated at any given time.
 */
public protocol ManuallyUpdatablePropertiesProvider: PropertiesProvider {

    /**
     Force the properties provider to update its properties.

     Note that there is no guarantee that the returned properties will be new, even
     if the date has updated.

     - Returns: The properties after the update.
     */
    func updateValues() -> [AnyProperty]

}
