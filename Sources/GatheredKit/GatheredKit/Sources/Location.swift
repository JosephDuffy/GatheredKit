import Foundation
import CoreLocation

// TODO: Wrap delegate to remove need for inheritance from `NSObject`
public final class Location: NSObject, Source, Controllable, Producer, PropertiesProvider {

    public typealias ProducedValue = [AnyProperty]

    private enum State {
        case notMonitoring
        case askingForPermissions(locationManager: CLLocationManager)
        case monitoring(locationManager: CLLocationManager)
    }

    public static var availability: SourceAvailability {
        let authorizationState = CLLocationManager.authorizationStatus()
        return SourceAvailability(authorizationStatus: authorizationState) ?? .unavailable
    }

    public static var name = "Location"

    public let coordinate: OptionalCoordinateValue
    public let speed: OptionalSpeedValue = .metersPerSecond(displayName: "Speed")
    public let course: OptionalAngleValue = .degrees(displayName: "Course")
    public let altitude: OptionalLengthValue = .meters(displayName: "Altitude")

    private var _floor = OptionalProperty<Int, NumberFormatter>(displayName: "Floor", formatter: NumberFormatter())
    @available(iOS 10.0, macOS 10.15, *)
    public var floor: OptionalProperty<Int, NumberFormatter> {
        return _floor
    }

    public let horizonalAccuracy: OptionalLengthValue = .meters(displayName: "Horizontal Accuracy")
    public let verticalAccuracy: OptionalLengthValue = .meters(displayName: "Vertical Accuracy")
    public let authorizationStatus = LocationAuthorizationValue(displayName: "Authorization Status", value: CLLocationManager.authorizationStatus())

    /**
     An array of all the properties associated with the location of the
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
    public var allProperties: [AnyProperty] {
        var properties: [AnyProperty] = [
            coordinate,
            speed,
            course,
            altitude,
            horizonalAccuracy,
            verticalAccuracy,
            authorizationStatus,
        ]

        if #available(iOS 10.0, macOS 10.15, *) {
            properties.append(floor)
        }

        return properties
    }

    public var isUpdating: Bool {
        if case .monitoring = state {
            return true
        } else {
            return false
        }
    }
    
    internal var consumers: [AnyConsumer] = []

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
        coordinate = .init(displayName: "Coordinate")
    }

    deinit {
        stopUpdating()
    }

    #if os(iOS)
    public func startUpdating() {
        startUpdating(allowBackgroundUpdates: false, desiredAccuracy: .best)
    }

    public func startUpdating(allowBackgroundUpdates: Bool = false, desiredAccuracy accuracy: Accuracy = .best) {
        startUpdating(desiredAccuracy: accuracy) { locationManager in
            locationManager.allowsBackgroundLocationUpdates = allowBackgroundUpdates
        }
    }
    #else
    public func startUpdating() {
        startUpdating(desiredAccuracy: .best)
    }

    public func startUpdating(desiredAccuracy accuracy: Accuracy = .best) {
        startUpdating(desiredAccuracy: accuracy, locationManagerConfigurator: nil)
    }
    #endif

    private func startUpdating(desiredAccuracy accuracy: Accuracy, locationManagerConfigurator: ((CLLocationManager) -> Void)?) {
        let locationManager: CLLocationManager = {
            if let locationManager = self.locationManager {
                return locationManager
            } else {
                let locationManager = CLLocationManager()
                locationManager.delegate = self
                locationManagerConfigurator?(locationManager)
                return locationManager
            }
        }()
        locationManager.desiredAccuracy = accuracy.asCLLocationAccuracy

        let authorizationStatus = CLLocationManager.authorizationStatus()
        self.authorizationStatus.update(value: authorizationStatus)
        
        defer {
            notifyUpdateConsumersOfLatestValues()
        }
        
        switch authorizationStatus {
        case .authorizedAlways:
            state = .monitoring(locationManager: locationManager)
            locationManager.startUpdatingLocation()
            updateValues()
        case .authorizedWhenInUse:
            #if os(iOS)
            if locationManager.allowsBackgroundLocationUpdates {
                state = .askingForPermissions(locationManager: locationManager)
                locationManager.requestAlwaysAuthorization()
            } else {
                state = .monitoring(locationManager: locationManager)
                locationManager.startUpdatingLocation()
                updateValues()
            }
            #endif
        case .notDetermined:
            state = .askingForPermissions(locationManager: locationManager)

            #if os(iOS)
            if locationManager.allowsBackgroundLocationUpdates {
                locationManager.requestAlwaysAuthorization()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
            #elseif os(macOS)
            if #available(OSX 10.15, *) {
                locationManager.requestAlwaysAuthorization()
            } else {
                locationManager.startUpdatingLocation()
            }
            #endif
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
        if let location = location {
            let timestamp = location.timestamp
            coordinate.update(value: location.coordinate, date: timestamp)

            if location.course < 0 {
                course.update(value: nil, formattedValue: "Unknown", date: timestamp)
            } else {
                course.update(value: location.speed, date: timestamp)
            }

            if location.speed < 0 {
                speed.update(value: nil, formattedValue: "Unknown", date: timestamp)
            } else {
                speed.update(value: location.speed, date: timestamp)
            }
            altitude.update(value: location.altitude, date: timestamp)
            if #available(iOS 10.0, OSX 10.15, *) {
                floor.update(value: location.floor?.level, date: timestamp)
            }
            horizonalAccuracy.update(value: location.horizontalAccuracy, date: timestamp)
            verticalAccuracy.update(value: location.verticalAccuracy, date: timestamp)
        } else {
            coordinate.update(value: nil)
            speed.update(value: nil)
            altitude.update(value: nil)
            if #available(OSX 10.15, *) {
                floor.update(value: nil)
            }
            horizonalAccuracy.update(value: nil)
            verticalAccuracy.update(value: nil)
        }
    }

}

extension Location: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != .notDetermined else { return }
        
        authorizationStatus.update(value: status)

        if Location.availability == .available, isAskingForLocationPermissions {
            // The user has just granted location permissions
            #if os(iOS)
                startUpdating(
                    allowBackgroundUpdates: manager.allowsBackgroundLocationUpdates,
                    desiredAccuracy: Location.Accuracy(accuracy: manager.desiredAccuracy) ?? .best
                )
            #elseif os(macOS)
            startUpdating(
                desiredAccuracy: Location.Accuracy(accuracy: manager.desiredAccuracy) ?? .best
            )
            #endif
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
        #if os(iOS)
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
        #elseif os(macOS)
        switch authorizationStatus {
        case .authorizedAlways:
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
        #endif
    }

}
