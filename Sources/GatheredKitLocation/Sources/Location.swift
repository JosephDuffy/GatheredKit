import Combine
import CoreLocation
import Foundation
import GatheredKit

public final class Location: UpdatingSource, Controllable {
    private enum State {
        case notMonitoring
        case askingForPermissions(locationManager: CLLocationManager, delegateProxy: CLLocationManagerDelegateProxy)
        case monitoring(locationManager: CLLocationManager, delegateProxy: CLLocationManagerDelegateProxy)
    }

    public private(set) var availability: SourceAvailability

    public let name = "Location"

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    @OptionalCoordinateProperty
    public private(set) var coordinate: CLLocationCoordinate2D?

    @OptionalMeasurementProperty(unit: .metersPerSecond)
    public private(set) var speed: Measurement<UnitSpeed>?

    @OptionalMeasurementProperty(unit: .degrees)
    public private(set) var course: Measurement<UnitAngle>?

    @OptionalMeasurementProperty(unit: .meters)
    public private(set) var altitude: Measurement<UnitLength>?

    @OptionalIntProperty
    public private(set) var floor: Int?

    @OptionalMeasurementProperty(unit: .meters)
    public private(set) var horizontalAccuracy: Measurement<UnitLength>?

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
        [
            $coordinate,
            $speed,
            $course,
            $altitude,
            $floor,
            $horizontalAccuracy,
            $verticalAccuracy,
            $authorizationStatus,
        ]
    }

    @Published
    public private(set) var isUpdating: Bool = false

    public var isUpdatingPublisher: AnyPublisher<Bool, Never> {
        $isUpdating.eraseToAnyPublisher()
    }

    private var locationManager: CLLocationManager? {
        switch state {
        case .monitoring(let locationManager, _), .askingForPermissions(let locationManager, _):
            return locationManager
        case .notMonitoring:
            return nil
        }
    }

    private var locationManagerDelegateProxy: CLLocationManagerDelegateProxy?

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
                eventsSubject.send(.stoppedUpdating())
            }
        }
    }

    public init() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        availability = SourceAvailability(authorizationStatus: authorizationStatus) ?? .unavailable

        _coordinate = .init(displayName: "Coordinate")
        _floor = .init(displayName: "Floor")
        #warning("TODO: Provide a custom formatter for 0 and negate values")
        _verticalAccuracy = .meters(displayName: "Vertical Accuracy")
        _authorizationStatus = .init(
            displayName: "Authorization Status", value: CLLocationManager.authorizationStatus()
        )
    }

    deinit {
        stopUpdating()
    }

    #if os(iOS) || os(watchOS)
    public func startUpdating() {
        startUpdating(allowBackgroundUpdates: false, desiredAccuracy: .best)
    }

    public func startUpdating(
        allowBackgroundUpdates: Bool = false, desiredAccuracy accuracy: Accuracy = .best
    ) {
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

    private func startUpdating(
        desiredAccuracy accuracy: Accuracy,
        locationManagerConfigurator: ((CLLocationManager) -> Void)?
    ) {
        let (locationManager, delegateProxy) = { () -> (CLLocationManager, CLLocationManagerDelegateProxy) in
            switch state {
            case .notMonitoring:
                let locationManager = CLLocationManager()
                let delegateProxy = CLLocationManagerDelegateProxy { [weak self] manager, status in
                    self?.locationManager(manager, didChangeAuthorization: status)
                } didUpdateLocations: { [weak self] manager, locations in
                    self?.locationManager(manager, didUpdateLocations: locations)
                }
                locationManager.delegate = delegateProxy
                return (locationManager, delegateProxy)
            case .monitoring(let locationManager, let delegateProxy), .askingForPermissions(let locationManager, let delegateProxy):
                return (locationManager, delegateProxy)
            }
        }()
        locationManager.desiredAccuracy = accuracy.asCLLocationAccuracy
        locationManagerConfigurator?(locationManager)

        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, macOS 11, tvOS 14, watchOS 7, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = type(of: locationManager).authorizationStatus()
        }
        _authorizationStatus.updateValueIfDifferent(authorizationStatus)
        let availability = SourceAvailability(authorizationStatus: authorizationStatus) ?? .unavailable
        if availability != self.availability {
            self.availability = availability
            eventsSubject.send(.availabilityUpdated(availability))
        }

        #if os(iOS) || os(watchOS)
        switch authorizationStatus {
        case .authorizedAlways:
            state = .monitoring(locationManager: locationManager, delegateProxy: delegateProxy)
            locationManager.startUpdatingLocation()
            updateValues()
        case .authorizedWhenInUse:
            if locationManager.allowsBackgroundLocationUpdates {
                state = .askingForPermissions(locationManager: locationManager, delegateProxy: delegateProxy)
                locationManager.requestAlwaysAuthorization()
            } else {
                state = .monitoring(locationManager: locationManager, delegateProxy: delegateProxy)
                locationManager.startUpdatingLocation()
                updateValues()
            }
        case .notDetermined:
            state = .askingForPermissions(locationManager: locationManager, delegateProxy: delegateProxy)

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
            state = .monitoring(locationManager: locationManager, delegateProxy: delegateProxy)
            locationManager.startUpdatingLocation()
            updateValues()
        case .authorizedWhenInUse:
            state = .monitoring(locationManager: locationManager, delegateProxy: delegateProxy)
            locationManager.startUpdatingLocation()
            updateValues()
        case .notDetermined:
            state = .askingForPermissions(locationManager: locationManager, delegateProxy: delegateProxy)
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
            state = .monitoring(locationManager: locationManager, delegateProxy: delegateProxy)
            locationManager.requestLocation()
            updateValues()
        case .notDetermined:
            state = .askingForPermissions(locationManager: locationManager, delegateProxy: delegateProxy)
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

            _coordinate.updateValue(location.coordinate, date: timestamp)

            if location.speed < 0 {
                _speed.updateValue(nil, date: timestamp)
            } else {
                _speed.updateMeasuredValue(location.speed, date: timestamp)
            }

            if location.course < 0 {
                _course.updateValue(nil, date: timestamp)
            } else {
                _course.updateMeasuredValue(location.speed, date: timestamp)
            }

            _altitude.updateMeasuredValue(location.altitude, date: timestamp)
            switch state {
            case .monitoring:
                _floor.updateValue(location.floor?.level, date: timestamp)
            case .askingForPermissions, .notMonitoring:
                // When not updating floor will be `2146959360`
                _floor.updateValue(nil, date: timestamp)
            }
            _horizontalAccuracy.updateMeasuredValue(location.horizontalAccuracy, date: timestamp)
            _verticalAccuracy.updateMeasuredValue(location.verticalAccuracy, date: timestamp)
        } else {
            _coordinate.updateValue(nil)
            _speed.updateValue(nil)
            _course.updateValue(nil)
            _altitude.updateValue(nil)
            _floor.updateValue(nil)
            _horizontalAccuracy.updateValue(nil)
            _verticalAccuracy.updateValue(nil)
        }
    }

    private func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        availability = SourceAvailability(authorizationStatus: status) ?? .unavailable
        eventsSubject.send(.availabilityUpdated(availability))

        _authorizationStatus.updateValue(status)

        switch availability {
        case .available:
            switch state {
            case .askingForPermissions:
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
            case .monitoring, .notMonitoring:
                break
            }
        case .requiresPermissionsPrompt:
            switch state {
            case .monitoring:
                stopUpdating()
            case .notMonitoring, .askingForPermissions:
                break
            }
        case .permissionDenied, .restricted, .unavailable:
            stopUpdating()
        }
    }

    private func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        locations.forEach(updateLocationValues(_:))
    }
}

private final class CLLocationManagerDelegateProxy: NSObject, CLLocationManagerDelegate {
    let didChangeAuthorization: (_ manager: CLLocationManager, _ status: CLAuthorizationStatus) -> Void
    let didUpdateLocations: (_ manager: CLLocationManager, _ locations: [CLLocation]) -> Void

    init(
        didChangeAuthorization: @escaping (_ manager: CLLocationManager, _ status: CLAuthorizationStatus) -> Void,
        didUpdateLocations: @escaping (_ manager: CLLocationManager, _ locations: [CLLocation]) -> Void
    ) {
        self.didChangeAuthorization = didChangeAuthorization
        self.didUpdateLocations = didUpdateLocations
    }

    func locationManager(
        _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus
    ) {
        didChangeAuthorization(manager, status)
    }

    public func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
        didUpdateLocations(manager, locations)
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
        case .authorized:
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
