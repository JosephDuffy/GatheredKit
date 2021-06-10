// @testable
// import GatheredKit
// import CoreLocation
// import Quick
// import Nimble
//
// internal final class MockLocationManager: LocationManager {
//
//    internal static var mockAuthorizationStatus: CLAuthorizationStatus!
//
//    private(set) internal static var mostRecentInstance: MockLocationManager?
//
//    static func authorizationStatus() -> CLAuthorizationStatus {
//        return mockAuthorizationStatus
//    }
//
//    var location: CLLocation?
//
//    weak var delegate: CLLocationManagerDelegate?
//
//    var mockDesiredAccuracy: CLLocationAccuracy!
//
//    var desiredAccuracy: CLLocationAccuracy {
//        get {
//            return mockDesiredAccuracy
//        }
//        set {
//            mockDesiredAccuracy = newValue
//        }
//    }
//
//    var mockAllowsBackgroundLocationUpdates: Bool!
//
//    var allowsBackgroundLocationUpdates: Bool {
//        get {
//            return mockAllowsBackgroundLocationUpdates
//        }
//        set {
//            mockAllowsBackgroundLocationUpdates = newValue
//        }
//    }
//
//    init() {
//        MockLocationManager.mostRecentInstance = self
//    }
//
//    internal var requestAlwaysAuthorizationHandler: (() -> Void)?
//
//    func requestAlwaysAuthorization() {
//        requestAlwaysAuthorizationHandler?()
//    }
//
//    internal var requestWhenInUseAuthorizationHandler: (() -> Void)?
//
//    func requestWhenInUseAuthorization() {
//        requestWhenInUseAuthorizationHandler?()
//    }
//
//    internal var startUpdatingLocationHandler: (() -> Void)?
//
//    func startUpdatingLocation() {
//        startUpdatingLocationHandler?()
//    }
//
//    internal var stopUpdatingLocationHandler: (() -> Void)?
//
//    func stopUpdatingLocation() {
//        stopUpdatingLocationHandler?()
//    }
//
// }
