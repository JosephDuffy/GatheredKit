import Combine
import CoreLocation
import Foundation
import GatheredKit
import GatheredKitMacros

@UpdatableProperty<CLLocationCoordinate2D?>
@propertyWrapper
public final class OptionalCoordinateProperty: UpdatableProperty, PropertiesProviding {
    @ChildProperty(\CLLocationCoordinate2D.latitude, unit: UnitAngle.degrees)
    public private(set) var latitude: Measurement<UnitAngle>? {
        get {
            _latitude.wrappedValue
        }
        set {
            _latitude.updateValue(newValue)
        }
    }

    @ChildProperty(\CLLocationCoordinate2D.longitude, unit: UnitAngle.degrees)
    public private(set) var longitude: Measurement<UnitAngle>? {
        get {
            _longitude.wrappedValue
        }
        set {
            _longitude.updateValue(newValue)
        }
    }
}
