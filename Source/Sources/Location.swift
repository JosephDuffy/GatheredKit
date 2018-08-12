import Foundation
import CoreLocation

public final class Location: BaseSource, Source, Controllable, ValuesProvider {

    private enum State {
        case notMonitoring
        case askingForPermissions(locationManager: CLLocationManager)
        case monitoring(locationManager: CLLocationManager)
    }

    public enum Accuracy {
        case bestForNavigation
        case best
        case tenMeters
        case hundredMeters
        case kilometer
        case threeKilometers

        var asCLLocationAccuracy: CLLocationAccuracy {
            switch self {
            case .bestForNavigation:
                return kCLLocationAccuracyBestForNavigation
            case .best:
                return kCLLocationAccuracyBest
            case .tenMeters:
                return kCLLocationAccuracyNearestTenMeters
            case .hundredMeters:
                return kCLLocationAccuracyHundredMeters
            case .kilometer:
                return kCLLocationAccuracyKilometer
            case .threeKilometers:
                return kCLLocationAccuracyThreeKilometers
            }
        }

        init?(accuracy: CLLocationAccuracy) {
            switch accuracy {
            case kCLLocationAccuracyBestForNavigation:
                self = .bestForNavigation
            case kCLLocationAccuracyBest:
                self = .best
            case kCLLocationAccuracyNearestTenMeters:
                self = .tenMeters
            case kCLLocationAccuracyHundredMeters:
                self = .hundredMeters
            case kCLLocationAccuracyKilometer:
                self = .kilometer
            case kCLLocationAccuracyThreeKilometers:
                self = .threeKilometers
            default:
                return nil
            }
        }

    }

    public static var availability: SourceAvailability {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            return .available
        case .denied:
            return .permissionDenied
        case .restricted:
            return .permissionDenied
        case .notDetermined:
            return .requiresPermissionsPrompt
        }
    }

    public static var name = "Location"

    public var coordinate: CoordinateValue
    public var speed: GenericValue<CLLocationSpeed?, MetersPerSecond>
    public var course: GenericValue<CLLocationDirection?, Degree>
    public var altitude: GenericValue<CLLocationDistance?, Meter>
    public var floor: GenericValue<CLFloor?, NumericNone>
    public var horizonalAccuracy: GenericValue<CLLocationAccuracy?, Meter>
    public var verticalAccuracy: GenericValue<CLLocationAccuracy?, Meter>
    public var authorizationStatus: GenericUnitlessValue<CLAuthorizationStatus?>

    /**
     An array of all the values associated with the location of the
     device, in the following order:
      - coordinate
      - speed
      - course
      - altitude
      - floor
      - horizonalAccuracy
      - verticalAccuracy
      - authorisationStatus
     */
    public var allValues: [Value] {
        return [
            coordinate,
            speed,
            course,
            altitude,
            floor,
            horizonalAccuracy,
            verticalAccuracy,
            authorizationStatus,
        ]
    }

    public var isUpdating: Bool {
        if case .notMonitoring = state {
            return true
        } else {
            return false
        }
    }

    private var locationManager: CLLocationManager? {
        if case .monitoring(let locationManager) = state {
            return locationManager
        } else {
            return nil
        }
    }

    private var isAskingForLocationPermissions: Bool {
        if case .askingForPermissions = state {
            return true
        } else {
            return false
        }
    }

    private var state: State = .notMonitoring

    public override init() {
        coordinate = CoordinateValue()
        speed = GenericValue(displayName: "Speed (estimated)")
        course = GenericValue(displayName: "Course")
        altitude = GenericValue(displayName: "Altitude")
        floor = GenericValue(displayName: "Floor")
        horizonalAccuracy = GenericValue(displayName: "Horizontal Accuracy")
        verticalAccuracy = GenericValue(displayName: "Vertical Accuracy")
        authorizationStatus = GenericUnitlessValue(displayName: "Authorization Status")
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating() {
        startUpdating(allowBackgroundUpdates: false, desiredAccuracy: .best)
    }

    public func startUpdating(allowBackgroundUpdates: Bool = false, desiredAccuracy accuracy: Accuracy = .best) {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = accuracy.asCLLocationAccuracy
        locationManager.allowsBackgroundLocationUpdates = allowBackgroundUpdates

        self.locationManager?.stopUpdatingLocation()

        let authorizationStatus = CLLocationManager.authorizationStatus()
        updateAuthorizationStatusValues(authorizationStatus)

        switch authorizationStatus {
        case .authorizedAlways:
            state = .monitoring(locationManager: locationManager)
            locationManager.startUpdatingLocation()
            updateValues()
        case .authorizedWhenInUse:
            if allowBackgroundUpdates {
                state = .askingForPermissions(locationManager: locationManager)
                locationManager.requestAlwaysAuthorization()
            } else {
                state = .monitoring(locationManager: locationManager)
                locationManager.startUpdatingLocation()
                updateValues()
            }
        case .notDetermined:
            state = .askingForPermissions(locationManager: locationManager)

            if allowBackgroundUpdates {
                locationManager.requestAlwaysAuthorization()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        case .denied, .restricted:
            /**
             This can be called when following happens:
             - User enabled data source
             - Permissions alert is displayed
             - This will cause the data source to stop being monitored
             - User denies access
             - Data source begins being monitored again

             Even though this _may_ be called in other situations,
             updating the data isn't a big operation anwyay
             */
            updateLocationValues(nil)
            state = .notMonitoring
            notifyListenersPropertyValuesUpdated()
        }
    }

    public func stopUpdating() {
        guard let locationManager = locationManager else { return }

        locationManager.stopUpdatingLocation()
        state = .notMonitoring
    }

    private func updateValues() {
        updateLocationValues(locationManager?.location)
        updateAuthorizationStatusValues(CLLocationManager.authorizationStatus())

        notifyListenersPropertyValuesUpdated()
    }

    private func updateAuthorizationStatusValues(_ status: CLAuthorizationStatus) {
        authorizationStatus.update(backingValue: status, formattedValue: status.formattedValue)
    }

    private func updateLocationValues(_ location: CLLocation? = nil) {
        coordinate.update(backingValue: location?.coordinate, date: location?.timestamp ?? Date())
        speed.update(backingValue: location?.speed, date: location?.timestamp ?? Date())
        altitude.update(backingValue: location?.altitude, date: location?.timestamp ?? Date())
        floor.update(backingValue: location?.floor, date: location?.timestamp ?? Date())
        horizonalAccuracy.update(backingValue: location?.horizontalAccuracy, date: location?.timestamp ?? Date())
        verticalAccuracy.update(backingValue: location?.verticalAccuracy, date: location?.timestamp ?? Date())
    }

}

extension Location: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }

        if Location.availability == .available, isAskingForLocationPermissions {
            // The user has just granted location permissions
            startUpdating(
                allowBackgroundUpdates: manager.allowsBackgroundLocationUpdates,
                desiredAccuracy: Location.Accuracy(accuracy: manager.desiredAccuracy) ?? .best
            )
        } else if isUpdating {
            notifyListenersPropertyValuesUpdated()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        updateLocationValues(location)
        notifyListenersPropertyValuesUpdated()
    }

}

private extension CLAuthorizationStatus {

    var formattedValue: String {
        switch self {
        case .authorizedAlways:
            return "Authorized Always"
        case .authorizedWhenInUse:
            return "Authorized When In Use"
        case .denied:
            return "Denied"
        case .notDetermined:
            return "Not Determined"
        case .restricted:
            return "Restricted"
        }
    }

}
