import Foundation
import CoreLocation
import Combine
import GatheredKitCore

// TODO: Wrap delegate to remove need for inheritance from `NSObject`
public final class Location: NSObject, Source, Controllable {

    private enum State {
        case notMonitoring
        case askingForPermissions(locationManager: CLLocationManager)
        case monitoring(locationManager: CLLocationManager)
    }

    public private(set) var availability: SourceAvailability

    public let name = "Location"

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return eventsSubject.eraseToAnyPublisher()
    }

    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    private var eventsSubject: PassthroughSubject<ControllableEvent, ControllableError> {
        return _eventsSubject as! PassthroughSubject<ControllableEvent, ControllableError>
    }

    private lazy var _eventsSubject: Any = {
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            return PassthroughSubject<ControllableEvent, ControllableError>()
        } else {
            fatalError()
        }
    }()

    @OptionalCoordinateProperty
    public private(set) var coordinate: CLLocationCoordinate2D?

    @OptionalSpeedProperty
    public private(set) var speed: Measurement<UnitSpeed>?

    @OptionalAngleProperty
    public private(set) var course: Measurement<UnitAngle>?

    @OptionalLengthProperty
    public private(set) var altitude: Measurement<UnitLength>?

    @OptionalIntProperty
    public private(set) var floor: Int?

    @OptionalLengthProperty
    public private(set) var horizonalAccuracy: Measurement<UnitLength>?

    @OptionalLengthProperty
    public private(set) var verticalAccuracy: Measurement<UnitLength>?

    @CLLocationAuthorizationProperty
    public private(set) var authorizationStatus: CLAuthorizationStatus

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
            $coordinate,
            $speed,
            $course,
            $altitude,
            $floor,
            $horizonalAccuracy,
            $verticalAccuracy,
            $authorizationStatus,
        ]
    }

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
                if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
                    eventsSubject.send(.startedUpdating)
                } else {
                    // Fallback on earlier versions
                }
            case .askingForPermissions:
                isUpdating = false
                if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
                    eventsSubject.send(.requestingPermission)
                } else {
                    // Fallback on earlier versions
                }
            case .notMonitoring:
                isUpdating = false
                if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
                    eventsSubject.send(completion: .finished)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    }

    public override init() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        availability = SourceAvailability(authorizationStatus: authorizationStatus) ?? .unavailable

        _coordinate = .init(displayName: "Coordinate")
        _speed = .metersPerSecond(displayName: "Speed")
        _course = .degrees(displayName: "Course")
        _altitude = .meters(displayName: "Altitude")
        _floor = .init(displayName: "Floor")
        _horizonalAccuracy = .meters(displayName: "Horizontal Accuracy")
        _verticalAccuracy = .meters(displayName: "Vertical Accuracy")
        _authorizationStatus = .init(displayName: "Authorization Status", value: CLLocationManager.authorizationStatus())

        super.init()
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
        _authorizationStatus.update(value: authorizationStatus)
        availability = SourceAvailability(authorizationStatus: authorizationStatus) ?? .unavailable

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
            _coordinate.update(value: location.coordinate, date: timestamp)

            if location.speed < 0 {
                // TODO: Provide formatted value
                _speed.update(value: nil, date: timestamp)
            } else {
                _speed.update(measuredValue: location.speed, date: timestamp)
            }

            if location.course < 0 {
                // TODO: Provide formatted value
                _course.update(value: nil, date: timestamp)
            } else {
                _course.update(measuredValue: location.speed, date: timestamp)
            }
            _altitude.update(measuredValue: location.altitude, date: timestamp)
            _floor.update(value: location.floor?.level, date: timestamp)
            _horizonalAccuracy.update(measuredValue: location.horizontalAccuracy, date: timestamp)
            _verticalAccuracy.update(measuredValue: location.verticalAccuracy, date: timestamp)
        } else {
            _coordinate.update(value: nil)
            _speed.update(value: nil)
            _course.update(value: nil)
            _altitude.update(value: nil)
            _floor.update(value: nil)
            _horizonalAccuracy.update(value: nil)
            _verticalAccuracy.update(value: nil)
        }
    }

}

extension Location: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        availability = SourceAvailability(authorizationStatus: status) ?? .unavailable
        if #available(iOS 13.0, tvOS 13.0, watchOS 6.0, *) {
            eventsSubject.send(.availabilityUpdated(availability))
        } else {
            // Fallback on earlier versions
        }

        _authorizationStatus.update(value: status)

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
