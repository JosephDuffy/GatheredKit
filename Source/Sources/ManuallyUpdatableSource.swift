
/**
 A source that supports its properties being updated at any given time
 */
public protocol ManuallyUpdatableSource: CustomisableUpdateIntervalSource {

    /**
     Force the source to update its properties. Note that there is no guarantee that new data
     will be available

     - returns: The property values after the update
     */
    func updateProperties() -> [AnyValue]

}
