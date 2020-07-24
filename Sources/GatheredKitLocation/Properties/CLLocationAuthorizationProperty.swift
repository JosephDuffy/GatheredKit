import CoreLocation
import GatheredKitCore

public typealias CLLocationAuthorizationProperty = BasicProperty<
    CLAuthorizationStatus, LocationAuthorizationFormatter
>
public typealias OptionalCLLocationAuthorizationProperty = BasicProperty<
    CLAuthorizationStatus?, LocationAuthorizationFormatter
>
