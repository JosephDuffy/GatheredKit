import Combine
import CoreLocation
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CLLocationCoordinate2D?>
@propertyWrapper
public final class OptionalCoordinateProperty: UpdatableProperty, PropertiesProviding {
    @PropertyValue(\CLLocationCoordinate2D.latitude, unit: UnitAngle.degrees)
    public private(set) var latitude: Measurement<UnitAngle>?

    @PropertyValue(\CLLocationCoordinate2D.longitude, unit: UnitAngle.degrees)
    public private(set) var longitude: Measurement<UnitAngle>?
}
