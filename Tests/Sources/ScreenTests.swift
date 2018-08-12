import UIKit
import Quick
import Nimble

@testable
import GatheredKit

final class ScreenTests: QuickSpec {

    override func spec() {
        describe("Screen") {

            context("initialised with mocked screen backing object") {

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
                    expect(screen.nativeScale.backingValue).to(equal(mock.nativeScale))
                }

                it("should set the `brightness` using the backing object's `brightness` property") {
                    expect(screen.brightness.backingValue).to(equal(mock.brightness))
                }

            }

            context(".startUpdating()") {

                var mock: MockScreenBackingData!
                var screen: Screen!
                var listenerWasCalled: Bool!
                var updateListener: AnyObject!
                // Silence Xcode warning
                _ = updateListener

                beforeEach {
                    mock = MockScreenBackingData()
                    screen = Screen(screen: mock)
                    listenerWasCalled = false
                    updateListener = screen.startUpdating(sendingUpdatesTo: { _ in
                        listenerWasCalled = true
                    })
                }

                it("should cause `isUpdating` to return `true`") {
                    expect(screen.isUpdating).to(beTrue())
                }

                it("should notify listeners when a `UIScreenBrightnessDidChange` notification is fired from the backing object") {
                    #if swift(>=4.2)
                    NotificationCenter.default.post(name: UIScreen.brightnessDidChangeNotification, object: mock)
                    #else
                    NotificationCenter.default.post(name: .UIScreenBrightnessDidChange, object: mock)
                    #endif

                    expect(listenerWasCalled).toEventually(beTrue())
                }

                it("should not notify listeners when a `UIScreenBrightnessDidChange` notification is fired from an object other than the backing object") {
                    #if swift(>=4.2)
                    NotificationCenter.default.post(name: UIScreen.brightnessDidChangeNotification, object: UIScreen.main)
                    #else
                    NotificationCenter.default.post(name: .UIScreenBrightnessDidChange, object: UIScreen.main)
                    #endif

                    var wasCalledAfterHalfASecond: Bool?

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        wasCalledAfterHalfASecond = listenerWasCalled
                    })

                    expect(wasCalledAfterHalfASecond).toEventually(beFalse(), timeout: 1, pollInterval: 0.1)
                }

            }
        }
    }

}
