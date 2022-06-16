import CoreLocation
import Combine
import GatheredKit
import NetworkExtension

// This _could_ be supported on iOS < 14 using CNCopyCurrentNetworkInfo.
@available(iOS 14.0, *)
public final class WiFiProvider: ManuallyUpdatableSingleTransientSourceProvider, UpdatingSourceProvider, AvailabilityProviding {
    public enum UpdateError: Error {
        case notAuthorized
    }

    public typealias RequestLocationPermissions = (_ locationManager: CLLocationManager) async -> CLAuthorizationStatus

    public typealias RequestTemporaryFullAccuracyAuthorization = (_ locationManager: CLLocationManager) async throws -> Void

    public typealias ProvidedSource = WiFi

    public let name: String

    @Published
    public private(set) var availability: SourceAvailability

    @Published
    public private(set) var source: WiFi?

    public var sourceProviderEventsPublisher: AnyPublisher<SourceProviderEvent<WiFi>, Never> {
        sourceProviderEventsSubject.eraseToAnyPublisher()
    }

    private let sourceProviderEventsSubject = PassthroughSubject<SourceProviderEvent<WiFi>, Never>()

    private let requestLocationPermissions: RequestLocationPermissions
    private let requestTemporaryFullAccuracyAuthorization: RequestTemporaryFullAccuracyAuthorization
    private let locationManager: CLLocationManager

    public required init(
        requestLocationPermissions: @escaping RequestLocationPermissions,
        requestTemporaryFullAccuracyAuthorization: @escaping RequestTemporaryFullAccuracyAuthorization,
        locationManager: CLLocationManager = CLLocationManager()
    ) {
        self.name = "Wi-Fi"
        self.requestLocationPermissions = requestLocationPermissions
        self.requestTemporaryFullAccuracyAuthorization = requestTemporaryFullAccuracyAuthorization
        self.locationManager = locationManager

        switch locationManager.authorizationStatus {
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            switch locationManager.accuracyAuthorization {
            case .fullAccuracy:
                availability = .available
            case .reducedAccuracy:
                availability = .requiresPermissionsPrompt
            @unknown default:
                availability = .unavailable
            }
        case .notDetermined:
            availability = .requiresPermissionsPrompt
        case .denied:
            availability = .permissionDenied
        case .restricted:
            availability = .restricted
        @unknown default:
            availability = .unavailable
        }

        // TODO: Become the delegate of `locationManager` to update availability
    }

    public func updateSource() async throws -> WiFi? {
        func continueWithStatus(_ authorizationStatus: CLAuthorizationStatus) async throws {
            switch authorizationStatus {
            case .authorized, .authorizedAlways, .authorizedWhenInUse:
                switch locationManager.accuracyAuthorization {
                case .fullAccuracy:
                    break
                case .reducedAccuracy:
                    try await requestTemporaryFullAccuracyAuthorization(locationManager)
                @unknown default:
                    throw UpdateError.notAuthorized
                }
            case .notDetermined:
                let resultingAuthorization = await requestLocationPermissions(locationManager)
                try await continueWithStatus(resultingAuthorization)
            case .denied, .restricted:
                throw UpdateError.notAuthorized
            @unknown default:
                throw UpdateError.notAuthorized
            }
        }

        try await continueWithStatus(locationManager.authorizationStatus)

        guard let connectedNetwork = await NEHotspotNetwork.fetchCurrent() else {
            if let existingSource = source {
                self.source = nil
                sourceProviderEventsSubject.send(.sourceRemoved(existingSource))
            }
            return nil
        }
        let newSource = WiFi(hostspotNetwork: connectedNetwork)
        if let existingSource = source {
            guard existingSource.hostspotNetwork != newSource.hostspotNetwork else {
                return existingSource
            }

            sourceProviderEventsSubject.send(.sourceRemoved(existingSource))
        }
        self.source = newSource
        sourceProviderEventsSubject.send(.sourceAdded(newSource))

        return newSource
    }
}
