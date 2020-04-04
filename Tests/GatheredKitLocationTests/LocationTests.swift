//@testable
//import GatheredKitLocation
//import CoreLocation
//import Quick
//import Nimble
//
//final class LocationTests: QuickSpec {
//
//    override func spec() {
//        describe("Location") {
//            var location: Location!
//            var locationManager: MockLocationManager? {
//                return MockLocationManager.mostRecentInstance
//            }
//
//            beforeSuite {
//                MockLocationManager.mockAuthorizationStatus = .notDetermined
//                Location.LocationManagerType = MockLocationManager.self
//            }
//
//            beforeEach {
//                location = Location()
//            }
//
//            context("after being initialised") {
//                it("should not create an instance of the location manager") {
//                    expect(locationManager).to(beNil())
//                }
//                it("should not have an altitude value") {
//                    expect(location.altitude.value).to(beNil())
//                }
//                it("should not have a coordinate value") {
//                    expect(location.coordinate.value).to(beNil())
//                }
//                it("should not have a course value") {
//                    expect(location.course.value).to(beNil())
//                }
//                it("should not have a floor value") {
//                    expect(location.floor.value).to(beNil())
//                }
//                it("should not have a horizonalAccuracy value") {
//                    expect(location.horizonalAccuracy.value).to(beNil())
//                }
//                it("should not have a speed value") {
//                    expect(location.speed.value).to(beNil())
//                }
//                it("should not have a verticalAccuracy value") {
//                    expect(location.verticalAccuracy.value).to(beNil())
//                }
//                it("should not be updating") {
//                    expect(location.isUpdating).to(beFalse())
//                }
//            }
//
//            context("startUpdating function") {
//                var allowBackgroundUpdates: Bool?
//                var desiredAccuracy: Location.Accuracy?
//                var requestAlwaysAuthorizationWasCalled = false
//
//                beforeEach {
//                    locationManager?.requestAlwaysAuthorizationHandler = {
//                        requestAlwaysAuthorizationWasCalled = true
//                    }
//
//                    switch (allowBackgroundUpdates, desiredAccuracy) {
//                    case (.some(let allowBackgroundUpdates), .some(let desiredAccuracy)):
//                        location.startUpdating(allowBackgroundUpdates: allowBackgroundUpdates, desiredAccuracy: desiredAccuracy)
//                    case (nil, .some(let desiredAccuracy)):
//                        location.startUpdating(desiredAccuracy: desiredAccuracy)
//                    case (.some(let allowBackgroundUpdates), nil):
//                        location.startUpdating(allowBackgroundUpdates: allowBackgroundUpdates)
//                    case (nil, nil):
//                        location.startUpdating()
//                    }
//                }
//
//                it("should create an instance of the location manager") {
//                    expect(locationManager).toNot(beNil())
//                }
//
//                context("passed `best` for `desiredAccuracy`") {
//                    beforeEach {
//                        desiredAccuracy = .best
//                    }
//
//                    it("should set `desiredAccuracy` on the location manager to kCLLocationAccuracyBest") {
//                        expect(locationManager!.desiredAccuracy).to(equal(kCLLocationAccuracyBest))
//                    }
//                }
//
//                context("passed false for allowBackgroundUpdates") {
//                    beforeEach {
//                        allowBackgroundUpdates = false
//                    }
//                }
//
//                context("passed true for allowBackgroundUpdates") {
//                    beforeEach {
//                        allowBackgroundUpdates = true
//                    }
//
//                    context("when the authorization status is authorizedWhenInUse") {
//                        beforeEach {
//                            // TODO: Set this earlier somehow?
//                            MockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
//                        }
//
//                        xit("should request permissions from the location manager using requestAlwaysAuthorization") {
//                            expect(requestAlwaysAuthorizationWasCalled).to(beTrue())
//                        }
//                    }
//                }
//            }
//
//            // TODO: Move these
//            context("when authorization status is notDetermined") {
//                beforeEach {
//                    MockLocationManager.mockAuthorizationStatus = .notDetermined
//                }
//
//                context("the static availability property") {
//                    it("should return requiresPermissionsPrompt") {
//                        expect(Location.availability).to(equal(.requiresPermissionsPrompt))
//                    }
//                }
//            }
//
//            context("when authorization status is authorizedWhenInUse") {
//                beforeEach {
//                    MockLocationManager.mockAuthorizationStatus = .authorizedWhenInUse
//                }
//
//                context("the static availability property") {
//                    it("should return available") {
//                        expect(Location.availability).to(equal(.available))
//                    }
//                }
//            }
//
//            context("#availability") {
//                context("when authorization status is notDetermined") {
//                    beforeEach {
//                        MockLocationManager.mockAuthorizationStatus = .notDetermined
//                    }
//
//                    it("should return requiresPermissionsPrompt") {
//                        expect(Location.availability).to(equal(.requiresPermissionsPrompt))
//                    }
//                }
//
//                context("when authorization status is restricted") {
//                    beforeEach {
//                        MockLocationManager.mockAuthorizationStatus = .restricted
//                    }
//
//                    it("should return permissionDenied") {
//                        expect(Location.availability).to(equal(.restricted))
//                    }
//                }
//
//                context("when authorization status is denied") {
//                    beforeEach {
//                        MockLocationManager.mockAuthorizationStatus = .denied
//                    }
//
//                    it("should return permissionDenied") {
//                        expect(Location.availability).to(equal(.permissionDenied))
//                    }
//                }
//
//                context("when authorization status is authorizedAlways") {
//                    beforeEach {
//                        MockLocationManager.mockAuthorizationStatus = .authorizedAlways
//                    }
//
//                    it("should return available") {
//                        expect(Location.availability).to(equal(.available))
//                    }
//                }
//                
//            }
//
//        }
//
//    }
//
//}
