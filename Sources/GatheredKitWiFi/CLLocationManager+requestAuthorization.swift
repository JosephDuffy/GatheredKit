import CoreLocation

extension CLLocationManager {
    /// Requests the user’s permission to use location services while the app is  in use.
    ///
    /// This is a wrapper around `CLLocationManager.requestWhenInUseAuthorization()`, providing an
    /// async API.
    ///
    /// While the user is making a selection the `delegate` will be set to a custom delegate used
    /// for handling the `locationManagerDidChangeAuthorization(_:)` function. This delegate will
    /// forward all calls to the current delegate. When the user has  made a selection the
    /// `delegate` will be set back to the original value.
    public func requestWhenInUseAuthorization() async -> CLAuthorizationStatus {
        #if os(macOS)
        switch authorizationStatus {
        case .authorizedAlways, .denied, .restricted:
            return authorizationStatus
        case .notDetermined:
            break
        @unknown default:
            break
        }
        #endif

        return await withCheckedContinuation { continuation in
            let ownDelegate = LocationDelegate { status in
                continuation.resume(returning: status)
            }
            ownDelegate.attach(to: self)
            requestWhenInUseAuthorization()
        }
    }

    /// Requests the user’s permission to use location services regardless of whether the app is in
    /// use.
    ///
    /// This is a wrapper around `CLLocationManager.requestAlwaysAuthorization()`, providing an
    /// async API.
    ///
    /// While the user is making a selection the `delegate` will be set to a custom delegate used
    /// for handling the `locationManagerDidChangeAuthorization(_:)` function. This delegate will
    /// forward all calls to the current delegate. When the user has  made a selection the
    /// `delegate` will be set back to the original value.
    public func requestAlwaysAuthorization() async -> CLAuthorizationStatus {
        #if os(macOS)
        switch authorizationStatus {
        case .authorizedAlways, .denied, .restricted:
            return authorizationStatus
        case .notDetermined:
            break
        @unknown default:
            break
        }
        #else
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse, .denied, .restricted:
            return authorizationStatus
        case .notDetermined:
            break
        @unknown default:
            break
        }
        #endif

        return await withCheckedContinuation { continuation in
            let ownDelegate = LocationDelegate { status in
                continuation.resume(returning: status)
            }
            ownDelegate.attach(to: self)
            requestAlwaysAuthorization()
        }
    }
}

private final class LocationDelegate: NSObject, CLLocationManagerDelegate {
    private let authorizationDidChangeHandler: (_ status: CLAuthorizationStatus) -> Void

    /// The original delegate to forward calls to while this delegate is installed.
    private weak var originalDelegate: CLLocationManagerDelegate?

    init(authorizationDidChangeHandler: @escaping (_ status: CLAuthorizationStatus) -> Void) {
        self.authorizationDidChangeHandler = authorizationDidChangeHandler

        super.init()
    }

    func attach(to locationManager: CLLocationManager) {
        originalDelegate = locationManager.delegate
        locationManager.delegate = self
        // Keep a strong reference via the location manager to enable it to be deinitialised.
        locationManager._gatheredKitLocationDelegate = self
    }

    // MARK: - Authorization changes

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationDidChangeHandler(manager.authorizationStatus)
        // Forward to original delegate if it implements this method
        originalDelegate?.locationManagerDidChangeAuthorization?(manager)
        manager.delegate = originalDelegate
        // This will release `self`.
        manager._gatheredKitLocationDelegate = nil
    }

    // MARK: - Forwarding other delegate methods

    override func responds(to aSelector: Selector!) -> Bool {
        if originalDelegate?.responds(to: aSelector) == true {
            return true
        }
        return super.responds(to: aSelector)
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if originalDelegate?.responds(to: aSelector) == true {
            return originalDelegate
        }
        return super.forwardingTarget(for: aSelector)
    }
}

extension CLLocationManager {
    @inline(never) private static var __associated_gatheredKitLocationDelegateKey: UnsafeRawPointer {
        let closure: @convention(c) () -> Void = {}
        return unsafeBitCast(closure, to: UnsafeRawPointer.self)
    }

    fileprivate var _gatheredKitLocationDelegate: LocationDelegate? {
        get {
            objc_getAssociatedObject(
                self,
                Self.__associated_gatheredKitLocationDelegateKey
            ) as? LocationDelegate
        }
        set {
            objc_setAssociatedObject(
                self,
                Self.__associated_gatheredKitLocationDelegateKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }
}
