import Foundation
import CoreLocation

public final class Compass: BaseSource, Source, Controllable, PropertiesProvider {

    private enum State {
        case notMonitoring
        case monitoring(locationManager: CLLocationManager)
    }

    public static var availability: SourceAvailability {
        return CLLocationManager.headingAvailable() ? .available : .unavailable
    }

    public static var name = "Heading"

    public var rawGeomagnetism = GeomagnetismValue()

    /**
     An array of all the properties associated with the location of the
     device, in the following order:
     -
     */
    public var allProperties: [AnyProperty] {
        return [
            rawGeomagnetism,
        ]
    }

    public var isUpdating: Bool {
        if case .monitoring = state {
            return true
        } else {
            return false
        }
    }

    private var locationManager: CLLocationManager? {
        switch state {
        case .monitoring(let locationManager):
            return locationManager
        case .notMonitoring:
            return nil
        }
    }

    private var state: State = .notMonitoring

    public override init() {}

    deinit {
        stopUpdating()
    }

    public func startUpdating() {
        startUpdating(allowBackgroundUpdates: false)
    }

    public func startUpdating(allowBackgroundUpdates: Bool = false) {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = allowBackgroundUpdates

        state = .monitoring(locationManager: locationManager)
        locationManager.startUpdatingHeading()
        updateValues()
    }

    public func stopUpdating() {
        guard let locationManager = locationManager else { return }

        locationManager.stopUpdatingHeading()
        state = .notMonitoring
    }

    private func updateValues() {
        updateHeadingValues(locationManager?.heading)

        notifyListenersPropertyValuesUpdated()
    }

    private func updateHeadingValues(_ location: CLHeading? = nil) {
        rawGeomagnetism.update(value: location)
    }

}

extension Compass: CLLocationManagerDelegate {

    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        updateHeadingValues(newHeading)
        notifyListenersPropertyValuesUpdated()
    }

}
