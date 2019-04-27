import Foundation
import CoreLocation

// TODO: Wrap delegate to remove need for inheritance from `NSObject`
public final class Location: NSObject, Source, Controllable, Producer, ValuesProvider {

    public typealias ProducedValue = [AnyValue]

    internal static var LocationManagerType: LocationManager.Type = CLLocationManager.self

    private enum State {
        case notMonitoring
        case askingForPermissions(locationManager: LocationManager)
        case monitoring(locationManager: LocationManager)
    }

    public static var availability: SourceAvailability {
        let authorizationState = LocationManagerType.authorizationStatus()
        return SourceAvailability(authorizationStatus: authorizationState) ?? .unavailable
    }

    public static var name = "Location"

    public let coordinate: OptionalCoordinateValue
    public let speed: OptionalSpeedValue = .metersPerSecond(displayName: "Speed")
    public let course: OptionalAngleValue = .degrees(displayName: "Course")
    public let altitude: OptionalLengthValue = .meters(displayName: "Altitude")
    public let floor = OptionalValue<CLFloor, NumberFormatter>(displayName: "Floor", formatter: NumberFormatter())
    public let horizonalAccuracy: OptionalLengthValue = .meters(displayName: "Horizontal Accuracy")
    public let verticalAccuracy: OptionalLengthValue = .meters(displayName: "Vertical Accuracy")
    public let authorizationStatus = LocationAuthorizationValue(displayName: "Authorization Status", backingValue: Location.LocationManagerType.authorizationStatus())

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
    public var allValues: [AnyValue] {
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
        if case .monitoring = state {
            return true
        } else {
            return false
        }
    }
    
    internal var consumers: [AnyConsumer] = []

    private var locationManager: LocationManager? {
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
        coordinate = .init(displayName: "Coordinate")
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating() {
        startUpdating(allowBackgroundUpdates: false, desiredAccuracy: .best)
    }

    public func startUpdating(allowBackgroundUpdates: Bool = false, desiredAccuracy accuracy: Accuracy = .best) {
        let locationManager: LocationManager = {
            if let locationManager = self.locationManager {
                return locationManager
            } else {
                let locationManager = Location.LocationManagerType.init()
                locationManager.delegate = self
                return locationManager
            }
        }()
        locationManager.desiredAccuracy = accuracy.asCLLocationAccuracy
        locationManager.allowsBackgroundLocationUpdates = allowBackgroundUpdates

        let authorizationStatus = Location.LocationManagerType.authorizationStatus()
        self.authorizationStatus.update(backingValue: authorizationStatus)
        
        defer {
            notifyUpdateConsumersOfLatestValues()
        }
        
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
            updateLocationValues(nil)
            state = .notMonitoring
            notifyUpdateConsumersOfLatestValues()
        @unknown default:
            break
        }
    }

    public func stopUpdating() {
        guard let locationManager = locationManager else { return }

        locationManager.stopUpdatingLocation()
        state = .notMonitoring
    }

    private func updateValues() {
        updateLocationValues(locationManager?.location)

        notifyUpdateConsumersOfLatestValues()
    }

    private func updateLocationValues(_ location: CLLocation? = nil) {
        let timestamp = location?.timestamp ?? Date()
        coordinate.update(backingValue: location?.coordinate, date: timestamp)
        speed.update(value: location?.speed, unit: .metersPerSecond, date: timestamp)
        altitude.update(value: location?.altitude, unit: .meters, date: timestamp)
        floor.update(backingValue: location?.floor, date: timestamp)
        horizonalAccuracy.update(value: location?.horizontalAccuracy, unit: .meters, date: timestamp)
        verticalAccuracy.update(value: location?.verticalAccuracy, unit: .meters, date: timestamp)
    }

}

extension Location: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        
        authorizationStatus.update(backingValue: status)

        if Location.availability == .available, isAskingForLocationPermissions {
            // The user has just granted location permissions
            startUpdating(
                allowBackgroundUpdates: manager.allowsBackgroundLocationUpdates,
                desiredAccuracy: Location.Accuracy(accuracy: manager.desiredAccuracy) ?? .best
            )
        } else if isUpdating {
            notifyUpdateConsumersOfLatestValues()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        updateLocationValues(location)
        notifyUpdateConsumersOfLatestValues()
    }

}

extension Location: ConsumersProvider { }

extension Location {

    public enum Accuracy {
        case bestForNavigation
        case best
        case tenMeters
        case hundredMeters
        case kilometer
        case threeKilometers

        public var asCLLocationAccuracy: CLLocationAccuracy {
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

        public init?(accuracy: CLLocationAccuracy) {
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

}

extension SourceAvailability {

    public init?(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self = .available
        case .denied:
            self = .permissionDenied
        case .restricted:
            self = .restricted
        case .notDetermined:
            self = .requiresPermissionsPrompt
        @unknown default:
            return nil
        }
    }

}

internal protocol LocationManager: class {
    static func authorizationStatus() -> CLAuthorizationStatus
    var location: CLLocation? { get }
    var delegate: CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var allowsBackgroundLocationUpdates: Bool { get set }
    init()
    func requestAlwaysAuthorization()
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

extension CLLocationManager: LocationManager {}
