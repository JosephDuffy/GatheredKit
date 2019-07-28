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
                    expect(screen.reportedResolution.value).to(equal(mock.bounds.size))
                }

                it("should set the `nativeScreenResolution` using the backing object's `nativeBounds` property") {
                    expect(screen.nativeResolution.value).to(equal(mock.nativeBounds.size))
                }

                it("should set the `reportedScreenScale` using the backing object's `scale` property") {
                    expect(screen.reportedResolution.value).to(equal(mock.bounds.size))
                }

                it("should set the `nativeScreenScale` using the backing object's `nativeScale` property") {
                    expect(screen.nativeScale.value).to(equal(mock.nativeScale.native))
                }

                it("should set the `brightness` using the backing object's `brightness` property") {
                    expect(screen.brightness.value).to(equal(mock.brightness.native))
                }

            }

            context("after `startUpdating` has been called") {
                var mockBackingData: MockScreenBackingData!
                var screen: Screen!
                var notificationCenter: MockNotificationCenter!
                var hasUpdateConsumerBeenDeallocated: Bool!
                var updateConsumer: MockValuesConsumer<[AnyProperty], Screen>!

                beforeEach {
                    mockBackingData = MockScreenBackingData()
                    notificationCenter = MockNotificationCenter()
                    screen = Screen(screen: mockBackingData, notificationCenter: notificationCenter)
                    updateConsumer = MockValuesConsumer()
                    hasUpdateConsumerBeenDeallocated = false
                    updateConsumer.deinitHandler = {
                        hasUpdateConsumerBeenDeallocated = true
                    }
                    screen.add(consumer: updateConsumer!)
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
                
                context("and the passed consumer is no longer being held on to") {
                    beforeEach {
                        updateConsumer = nil
                    }
                    
                    it("should deallocate the consumer") {
                        expect(hasUpdateConsumerBeenDeallocated).to(beTrue())
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
                        expect(updateConsumer.latestValues).to(containElementSatisfying({ value in
                            guard let value = value as? PercentValue else { return false }
                            guard value.displayName == screen.brightness.displayName else { return false }
                            return value.value == mockBackingData.brightness.native
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
