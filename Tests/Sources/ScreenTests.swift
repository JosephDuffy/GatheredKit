import UIKit
import Quick
import Nimble

@testable
import GatheredKit

final class ScreenTests: QuickSpec {

    override func spec() {
        describe("Screen") {
            context("init") {
                var mock: MockScreenBackingData!
                var screen: Screen!

                beforeEach {
                    mock = MockScreenBackingData()
                    screen = Screen(screen: mock)
                }

                it("should set the `reportedScreenResolution` using the backing object's `bounds.size` property") {
                    expect(screen.reportedResolution.backingValue).to(equal(mock.bounds.size))
                }

                it("should set the `nativeScreenResolution` using the backing object's `nativeBounds` property") {
                    expect(screen.nativeResolution.backingValue).to(equal(mock.nativeBounds.size))
                }

                it("should set the `reportedScreenScale` using the backing object's `scale` property") {
                    expect(screen.reportedResolution.backingValue).to(equal(mock.bounds.size))
                }

                it("should set the `nativeScreenScale` using the backing object's `nativeScale` property") {
                    expect(screen.nativeScale.backingValue).to(equal(mock.nativeScale.native))
                }

                it("should set the `brightness` using the backing object's `brightness` property") {
                    expect(screen.brightness.backingValue).to(equal(mock.brightness.native))
                }

            }

            context("after `startUpdating` has been called") {
                var mockBackingData: MockScreenBackingData!
                var screen: Screen!
                var notificationCenter: MockNotificationCenter!
                var updateConsumer: MockUpdateConsumer!

                beforeEach {
                    mockBackingData = MockScreenBackingData()
                    notificationCenter = MockNotificationCenter()
                    screen = Screen(screen: mockBackingData, notificationCenter: notificationCenter)
                    updateConsumer = MockUpdateConsumer()
                    screen.add(updatesConsumer: updateConsumer)
                    screen.startUpdating()
                }
                
                it("should add an observer to the notification center once") {
                    expect(notificationCenter.addObserverLatestParmetersCallCount).to(equal(1))
                }
                
                it("should add an observer for the UIScreenBrightnessDidChange notification") {
                    expect(notificationCenter.latestName!).to(equal(UIScreen.brightnessDidChangeNotification))
                }
                
                it("should add an observer for the backing screen") {
                    expect(notificationCenter.latestObject!).to(be(mockBackingData))
                }
                
                context("twice") {
                    beforeEach {
                        screen.startUpdating()
                    }

                    it("should add an observer to the notification center once") {
                        expect(notificationCenter.addObserverLatestParmetersCallCount).to(equal(1))
                    }
                }
                
                context("the `isUpdating` property") {
                    it("should be `true`") {
                        expect(screen.isUpdating).to(beTrue())
                    }
                }
                
                context("when a `UIScreen.brightnessDidChangeNotification` notification is fired from the backing object") {
                    beforeEach {
                        mockBackingData.brightness = 0.53
                        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification, object: mockBackingData)
                    }
                    
                    it("should notify update consumers synchronously") {
                        expect(updateConsumer.hasBeenCalled).to(beTrue())
                    }
                    
                    it("should pass the new value to the update listener") {
                        expect(updateConsumer.latestValues ?? []).to(containElementSatisfying({ value in
                            guard let value = value as? PercentValue else { return false }
                            guard value.displayName == screen.brightness.displayName else { return false }
                            return value.backingValue == mockBackingData.brightness.native
                        }))
                    }
                }
                
                context("when a `UIScreen.brightnessDidChangeNotification` notification is fired from an object that isn't the backing object") {
                    it("should not notify update consumers") {
                        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification, object: UIScreen.main)

                        expect(updateConsumer.hasBeenCalled).to(beFalse())
                    }
                }

            }
        }
    }

}
