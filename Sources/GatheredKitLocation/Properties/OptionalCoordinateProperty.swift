import Combine
import CoreLocation
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CLLocationCoordinate2D?>
@propertyWrapper
public final class OptionalCoordinateProperty: UpdatableProperty, PropertiesProviding {
    @ChildProperty(\CLLocationCoordinate2D.latitude, unit: UnitAngle.degrees)
    @OptionalAngleProperty
    public private(set) var latitude: Measurement<UnitAngle>?

    @ChildProperty(\CLLocationCoordinate2D.longitude, unit: UnitAngle.degrees)
    @OptionalAngleProperty
    public private(set) var longitude: Measurement<UnitAngle>?
}
