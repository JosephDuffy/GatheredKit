import CoreLocation

extension CLLocationManager {
    /// Requests the user’s permission to use location services while the app is
    /// in use.
    ///
    /// This is a wrapper around
    /// `CLLocationManager.requestWhenInUseAuthorization()`, providing an async
    /// API.
    ///
    /// While the user is making a selection the `delegate` will be set to a
    /// custom delegate used for handling the
    /// `locationManagerDidChangeAuthorization(_:)` function. When the user has
    /// made a selection the `delegate` will be set back to the original value.
    public func requestWhenInUseAuthorization() async -> CLAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            let previousDelegate = delegate
            let ownDelegate = LocationDelegate { [self] status in
                self.delegate = previousDelegate
                continuation.resume(returning: status)
            }
            delegate = ownDelegate
            requestWhenInUseAuthorization()
        }
    }

    /// Requests the user’s permission to use location services regardless of
    /// whether the app is in use.
    ///
    /// This is a wrapper around
    /// `CLLocationManager.requestAlwaysAuthorization()`, providing an async
    /// API.
    ///
    /// While the user is making a selection the `delegate` will be set to a
    /// custom delegate used for handling the
    /// `locationManagerDidChangeAuthorization(_:)` function. When the user has
    /// made a selection the `delegate` will be set back to the original value.
    public func requestAlwaysAuthorization() async -> CLAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            let previousDelegate = delegate
            let ownDelegate = LocationDelegate { [self] status in
                self.delegate = previousDelegate
                continuation.resume(returning: status)
            }
            delegate = ownDelegate
            requestAlwaysAuthorization()
        }
    }
}

private final class LocationDelegate: NSObject, CLLocationManagerDelegate {
    private let authorizationDidChangeHandler: (_ status: CLAuthorizationStatus) -> Void

    /// A reference to `self`, used to prevent the delegate for being
    /// deallocated while the user is making a selection.
    private var strongSelf: LocationDelegate?

    init(authorizationDidChangeHandler: @escaping (_ status: CLAuthorizationStatus) -> Void) {
        self.authorizationDidChangeHandler = authorizationDidChangeHandler

        super.init()

        strongSelf = self
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationDidChangeHandler(manager.authorizationStatus)
        strongSelf = nil
    }
}
