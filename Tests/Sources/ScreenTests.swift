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
                    expect(screen.reportedScreenResolution.value).to(equal(mock.bounds.size))
                }

                it("should set the `nativeScreenResolution` using the backing object's `nativeBounds` property") {
                    expect(screen.nativeScreenResolution.value).to(equal(mock.nativeBounds.size))
                }

                it("should set the `reportedScreenScale` using the backing object's `scale` property") {
                    expect(screen.reportedScreenResolution.value).to(equal(mock.bounds.size))
                }

                it("should set the `nativeScreenScale` using the backing object's `nativeScale` property") {
                    expect(screen.nativeScreenScale.value).to(equal(mock.nativeScale))
                }

                it("should set the `brightness` using the backing object's `brightness` property") {
                    expect(screen.brightness.value).to(equal(mock.brightness))
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
                    updateListener = screen.startUpdating { _ in
                        listenerWasCalled = true
                    }
                }

                it("should cause `isUpdating` to return `true`") {
                    expect(screen.isUpdating).to(beTrue())
                }

                context("called before a `UIScreenBrightnessDidChange` notification is fired from the backing object") {

                    beforeEach {
                        NotificationCenter.default.post(name: .UIScreenBrightnessDidChange, object: mock)
                    }

                    it("should notify listeners") {
                        expect(listenerWasCalled).to(beTrue())
                    }
                }

                context("called before a `UIScreenBrightnessDidChange` notification is fired from an object other than the backing object") {

                    beforeEach {
                        NotificationCenter.default.post(name: .UIScreenBrightnessDidChange, object: UIScreen.main)
                    }

                    it("should notify listeners") {
                        expect(listenerWasCalled).to(beFalse())
                    }
                }

            }
        }
    }

}
