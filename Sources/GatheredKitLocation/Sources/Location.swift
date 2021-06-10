import Combine
import CoreLocation
import Foundation
import GatheredKit

// TODO: Wrap delegate to remove need for inheritance from `NSObject`
public final class Location: NSObject, UpdatingSource, Controllable {
    private enum State {
        case notMonitoring
        case askingForPermissions(locationManager: CLLocationManager)
        case monitoring(locationManager: CLLocationManager)
    }

    public private(set) var availability: SourceAvailability

    public let name = "Location"

    public var sourceEventPublisher: AnyUpdatePublisher<SourceEvent> {
        sourceEventsSubject.eraseToAnyUpdatePublisher()
    }

    private let sourceEventsSubject: UpdateSubject<SourceEvent>

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
        [
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
                sourceEventsSubject.notifyUpdateListeners(of: .startedUpdating)
            case .askingForPermissions:
                isUpdating = false
                sourceEventsSubject.notifyUpdateListeners(of: .requestingPermission)
            case .notMonitoring:
                isUpdating = false
                sourceEventsSubject.notifyUpdateListeners(of: .stoppedUpdating())
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
        _authorizationStatus = .init(
            displayName: "Authorization Status", value: CLLocationManager.authorizationStatus()
        )

        sourceEventsSubject = UpdateSubject()

        super.init()
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
        _authorizationStatus.updateValueIfDifferent(authorizationStatus)
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
        let coordinateSnapshot: Snapshot<CLLocationCoordinate2D?>
        let speedSnapshot: Snapshot<Measurement<UnitSpeed>?>
        let courseSnapshot: Snapshot<Measurement<UnitAngle>?>
        let altitudeSnapshot: Snapshot<Measurement<UnitLength>?>
        let floorSnapshot: Snapshot<Int?>
        let horizonalAccuracySnapshot: Snapshot<Measurement<UnitLength>?>
        let verticalAccuracySnapshot: Snapshot<Measurement<UnitLength>?>

        defer {
            sourceEventsSubject.notifyUpdateListeners(of: .propertyUpdated(property: $coordinate, snapshot: coordinateSnapshot))
            sourceEventsSubject.notifyUpdateListeners(of: .propertyUpdated(property: $speed, snapshot: speedSnapshot))
            sourceEventsSubject.notifyUpdateListeners(of: .propertyUpdated(property: $course, snapshot: courseSnapshot))
            sourceEventsSubject.notifyUpdateListeners(of: .propertyUpdated(property: $altitude, snapshot: altitudeSnapshot))
            sourceEventsSubject.notifyUpdateListeners(of: .propertyUpdated(property: $floor, snapshot: floorSnapshot))
            sourceEventsSubject.notifyUpdateListeners(of: .propertyUpdated(property: $horizonalAccuracy, snapshot: horizonalAccuracySnapshot))
            sourceEventsSubject.notifyUpdateListeners(of: .propertyUpdated(property: $verticalAccuracy, snapshot: verticalAccuracySnapshot))
        }

        if let location = location {
            let timestamp = location.timestamp

            coordinateSnapshot = _coordinate.updateValue(location.coordinate, date: timestamp)

            if location.speed < 0 {
                // TODO: Provide formatted value
                speedSnapshot = _speed.updateValue(nil, date: timestamp)
            } else {
                speedSnapshot = _speed.updateMeasuredValue(location.speed, date: timestamp)
            }

            if location.course < 0 {
                // TODO: Provide formatted value
                courseSnapshot = _course.updateValue(nil, date: timestamp)
            } else {
                courseSnapshot = _course.updateMeasuredValue(location.speed, date: timestamp)
            }

            altitudeSnapshot = _altitude.updateMeasuredValue(location.altitude, date: timestamp)
            floorSnapshot = _floor.updateValue(location.floor?.level, date: timestamp)
            horizonalAccuracySnapshot = _horizonalAccuracy.updateMeasuredValue(location.horizontalAccuracy, date: timestamp)
            verticalAccuracySnapshot = _verticalAccuracy.updateMeasuredValue(location.verticalAccuracy, date: timestamp)
        } else {
            coordinateSnapshot = _coordinate.updateValue(nil)
            speedSnapshot = _speed.updateValue(nil)
            courseSnapshot = _course.updateValue(nil)
            altitudeSnapshot = _altitude.updateValue(nil)
            floorSnapshot = _floor.updateValue(nil)
            horizonalAccuracySnapshot = _horizonalAccuracy.updateValue(nil)
            verticalAccuracySnapshot = _verticalAccuracy.updateValue(nil)
        }
    }
}

extension Location: CLLocationManagerDelegate {
    public func locationManager(
        _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus
    ) {
        availability = SourceAvailability(authorizationStatus: status) ?? .unavailable
        sourceEventsSubject.notifyUpdateListeners(of: .availabilityUpdated(availability))

        let snapshot = _authorizationStatus.updateValue(status)
        sourceEventsSubject.notifyUpdateListeners(of: .propertyUpdated(property: $authorizationStatus, snapshot: snapshot))

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

    public func locationManager(
        _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
    ) {
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
