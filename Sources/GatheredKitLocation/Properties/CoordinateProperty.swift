import Combine
import CoreLocation
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CLLocationCoordinate2D>
@propertyWrapper
public final class CoordinateProperty: UpdatableProperty, PropertiesProviding {
    @ChildProperty(\CLLocationCoordinate2D.latitude, unit: UnitAngle.degrees)
    @AngleProperty
    public private(set) var latitude: Measurement<UnitAngle>

    @ChildProperty(\CLLocationCoordinate2D.longitude, unit: UnitAngle.degrees)
    @AngleProperty
    public private(set) var longitude: Measurement<UnitAngle>
}
