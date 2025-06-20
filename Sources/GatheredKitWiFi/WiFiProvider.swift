#if canImport(NetworkExtension)
import CoreLocation
import Combine
import GatheredKit
@preconcurrency import NetworkExtension

// This _could_ be supported on iOS < 14 using CNCopyCurrentNetworkInfo.
@available(iOS 14, watchOS 7, macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
public final class WiFiProvider: ManuallyUpdatableSingleTransientSourceProvider, UpdatingSourceProvider, AvailabilityProviding {
    public enum UpdateError: Error {
        case notAuthorized
    }

    /// A closure used to request permission to access the user's location. Core
    /// Location does not provide an async or closure-based API for this, so the
    /// implementation of this is left up to the caller.
    ///
    /// An example implementation is provided in [CLLocationManager+requestAuthorization.swift](CLLocationManager+requestAuthorization.swift).
    ///
    /// You could also use a 3rd party package such as https://github.com/AsyncSwift/AsyncLocationKit
    public typealias RequestLocationPermissions = @MainActor (_ locationManager: CLLocationManager) async -> CLAuthorizationStatus

    /// A closure used to request temporary permission to access full accuracy
    /// location data. This will only be called when the user has authorised
    /// access to location data, but has provided reduced accuracy. An example
    /// implementation of this would be:
    ///
    /// ```swift
    /// try await locationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "<YOUR_KEY>")
    /// ```
    public typealias RequestTemporaryFullAccuracyAuthorization = @MainActor (_ locationManager: CLLocationManager) async throws -> Void

    public typealias ProvidedSource = WiFi

    public let id: SourceProviderIdentifier

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
        self.id = SourceProviderIdentifier(sourceKind: .wifi)
        self.requestLocationPermissions = requestLocationPermissions
        self.requestTemporaryFullAccuracyAuthorization = requestTemporaryFullAccuracyAuthorization
        self.locationManager = locationManager

        #if os(iOS) || os(tvOS) || os(watchOS)
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
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
        #elseif os(macOS)
        availability = .unavailable
        #endif

        // TODO: Become the delegate of `locationManager` to update availability
    }

    public func updateSource() async throws -> WiFi? {
        #if os(iOS) || os(tvOS) || os(watchOS)
        func continueWithStatus(_ authorizationStatus: CLAuthorizationStatus) async throws {
            switch authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
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
        #elseif os(macOS)
        return nil
        #endif
    }
}
#endif
