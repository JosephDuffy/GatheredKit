import CoreLocation
import GatheredKit

public typealias CLLocationAuthorizationProperty = BasicProperty<
    CLAuthorizationStatus, LocationAuthorizationFormatter
>
public typealias OptionalCLLocationAuthorizationProperty = BasicProperty<
    CLAuthorizationStatus?, LocationAuthorizationFormatter
>
