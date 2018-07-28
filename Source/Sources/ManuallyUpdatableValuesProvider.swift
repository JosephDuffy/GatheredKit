
/**
 A source that supports its properties being updated at any given time
 */
public protocol ManuallyUpdatableValuesProvider: ValuesProvider {

    /**
     Force the values provider to update its values.

     Note that there is no guarantee that the returned values will be new, even
     if the date has updated

     - returns: The values after the update
     */
    func updateValues() -> [AnyValue]

}
