import Foundation
import CoreLocation
import Combine

// TODO: Wrap delegate to remove need for inheritance from `NSObject`
public final class Location: NSObject, Source, Controllable {

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

    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return eventsSubject.eraseToAnyPublisher()
    }
    
    private var eventsSubject = PassthroughSubject<ControllableEvent, ControllableError>()

    public let coordinate: OptionalCoordinateValue = .init(displayName: "Coordinate")
    public let speed: OptionalSpeedValue = .metersPerSecond(displayName: "Speed")
    public let course: OptionalAngleValue = .degrees(displayName: "Course")
    public let altitude: OptionalLengthValue = .meters(displayName: "Altitude")

    public let floor = OptionalProperty<Int, NumberFormatter>(displayName: "Floor", formatter: NumberFormatter())

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
        return [
            coordinate,
            speed,
            course,
            altitude,
            horizonalAccuracy,
            verticalAccuracy,
            authorizationStatus,
            floor,
        ]
    }

    @Published
    public var isUpdating: Bool = false

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

    private var state: State = .notMonitoring {
        didSet {
            switch state {
            case .monitoring:
                isUpdating = true
                eventsSubject.send(.startedUpdating)
            case .askingForPermissions:
                isUpdating = false
                eventsSubject.send(.requestingPermission)
            case .notMonitoring:
                isUpdating = false
                eventsSubject.send(completion: .finished)
            }
        }
    }

    private var propertyUpdateCancellables: [AnyCancellable] = []

    public override init() {
        super.init()
        
//        propertyUpdateCancellables = publishUpdateWhenAnyPropertyUpdates()
    }

    deinit {
        stopUpdating()
    }

    #if os(iOS) || os(watchOS)
    public func startUpdating() {
        startUpdating(allowBackgroundUpdates: false, desiredAccuracy: .best)
    }

    public func startUpdating(allowBackgroundUpdates: Bool = false, desiredAccuracy accuracy: Accuracy = .best) {
        startUpdating(desiredAccuracy: accuracy) { locationManager in
            locationManager.allowsBackgroundLocationUpdates = allowBackgroundUpdates
        }
    }
    #elseif os(macOS) || os(tvOS)
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
                return locationManager
            }
        }()
        locationManager.desiredAccuracy = accuracy.asCLLocationAccuracy
        locationManagerConfigurator?(locationManager)

        let authorizationStatus = CLLocationManager.authorizationStatus()
        self.authorizationStatus.update(value: authorizationStatus)

        #if os(iOS) || os(watchOS)
        switch authorizationStatus {
        case .authorizedAlways:
            state = .monitoring(locationManager: locationManager)
            locationManager.startUpdatingLocation()
            updateValues()
        case .authorizedWhenInUse:
            if locationManager.allowsBackgroundLocationUpdates {
                state = .askingForPermissions(locationManager: locationManager)
                locationManager.requestAlwaysAuthorization()
            } else {
                state = .monitoring(locationManager: locationManager)
                locationManager.startUpdatingLocation()
                updateValues()
            }
        case .notDetermined:
            state = .askingForPermissions(locationManager: locationManager)

            if locationManager.allowsBackgroundLocationUpdates {
                locationManager.requestAlwaysAuthorization()
            } else {
                locationManager.requestWhenInUseAuthorization()
            }
        case .denied, .restricted:
            updateLocationValues(nil)
            state = .notMonitoring
        @unknown default:
            break
        }
        #elseif os(macOS)
        switch authorizationStatus {
        case .authorizedAlways:
            state = .monitoring(locationManager: locationManager)
            locationManager.startUpdatingLocation()
            updateValues()
        case .authorizedWhenInUse:
            state = .monitoring(locationManager: locationManager)
            locationManager.startUpdatingLocation()
            updateValues()
        case .notDetermined:
            state = .askingForPermissions(locationManager: locationManager)
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            updateLocationValues(nil)
            state = .notMonitoring
        @unknown default:
            break
        }
        #elseif os(tvOS)
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            state = .monitoring(locationManager: locationManager)
            locationManager.requestLocation()
            updateValues()
        case .notDetermined:
            state = .askingForPermissions(locationManager: locationManager)
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            updateLocationValues(nil)
            state = .notMonitoring
        @unknown default:
            break
        }
        #endif
    }

    public func stopUpdating() {
        guard let locationManager = locationManager else { return }

        locationManager.stopUpdatingLocation()
        state = .notMonitoring
    }

    private func updateValues() {
        updateLocationValues(locationManager?.location)
    }

    private func updateLocationValues(_ location: CLLocation? = nil) {
        if let location = location {
            let timestamp = location.timestamp
            coordinate.update(value: location.coordinate, date: timestamp)

            if location.course < 0 {
                // TODO: Provide formatted value
                course.update(value: nil, date: timestamp)
            } else {
                course.update(value: location.speed, date: timestamp)
            }

            if location.speed < 0 {
                // TODO: Provide formatted value
                speed.update(value: nil, date: timestamp)
            } else {
                speed.update(value: location.speed, date: timestamp)
            }
            altitude.update(value: location.altitude, date: timestamp)
            floor.update(value: location.floor?.level, date: timestamp)
            horizonalAccuracy.update(value: location.horizontalAccuracy, date: timestamp)
            verticalAccuracy.update(value: location.verticalAccuracy, date: timestamp)
        } else {
            coordinate.update(value: nil)
            course.update(value: nil)
            speed.update(value: nil)
            altitude.update(value: nil)
            floor.update(value: nil)
            horizonalAccuracy.update(value: nil)
            verticalAccuracy.update(value: nil)
        }
    }

}

extension Location: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let availability = Location.availability
        eventsSubject.send(.availabilityUpdated(availability))
        
        authorizationStatus.update(value: status)
        
        switch availability {
        case .available:
            guard isAskingForLocationPermissions else { return }
            // The user has just granted location permissions
            #if os(iOS) || os(watchOS)
            startUpdating(
                allowBackgroundUpdates: manager.allowsBackgroundLocationUpdates,
                desiredAccuracy: Location.Accuracy(accuracy: manager.desiredAccuracy) ?? .best
            )
            #elseif os(macOS) || os(tvOS)
            startUpdating(
                desiredAccuracy: Location.Accuracy(accuracy: manager.desiredAccuracy) ?? .best
            )
            #endif
        case .permissionDenied, .requiresPermissionsPrompt, .restricted, .unavailable:
            stopUpdating()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.forEach(updateLocationValues(_:))
    }

}

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
        #if os(iOS) || os(tvOS) || os(watchOS)
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
