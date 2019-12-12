#if canImport(UIKit)
import UIKit
import XCTest
@testable
import GatheredKit

final class ScreenTests: XCTestCase {

    func testValues() {
        let mock = MockScreenBackingData()
        let screen = Screen(screen: mock)
        XCTAssertEqual(screen.reportedResolution.value, mock.bounds.size)
        XCTAssertEqual(screen.nativeResolution.value, mock.nativeBounds.size)
        XCTAssertEqual(screen.reportedScale.value, mock.scale)
        XCTAssertEqual(screen.nativeScale.value, mock.nativeScale)
        XCTAssertEqual(screen.brightness.value, mock.brightness)
    }

    func testAutomaticUpdates() {
        let mockBackingData = MockScreenBackingData()
        let notificationCenter = MockNotificationCenter()
        let screen = Screen(screen: mockBackingData, notificationCenter: notificationCenter)
        var updateConsumer: MockValuesConsumer? = MockValuesConsumer<[AnyProperty], Screen>()
        var hasUpdateConsumerBeenDeallocated = false
        updateConsumer!.deinitHandler = {
            hasUpdateConsumerBeenDeallocated = true
        }

        screen.add(consumer: updateConsumer!)
        screen.startUpdating()

        XCTAssertTrue(screen.isUpdating)

        XCTAssertEqual(notificationCenter.addObserverLatestParmetersCallCount, 1)
        XCTAssertEqual(notificationCenter.latestName, UIScreen.brightnessDidChangeNotification)
        XCTAssertTrue(notificationCenter.latestObject as? MockScreenBackingData === mockBackingData)

        screen.startUpdating()

        XCTAssertEqual(notificationCenter.addObserverLatestParmetersCallCount, 1)

        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification, object: UIScreen.main)
        XCTAssertFalse(updateConsumer!.hasBeenCalled, "Notifications from a different object should not call the update consumer")

        mockBackingData.brightness = 0.53
        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification, object: mockBackingData)

        XCTAssertTrue(updateConsumer!.hasBeenCalled)
        XCTAssertTrue(updateConsumer!.latestValues!.contains(where: { property in
            guard let value = property.value as? CGFloat else { return false }
            guard property.displayName == screen.brightness.displayName else { return false }
            return value == mockBackingData.brightness
        }))

        updateConsumer = nil
        XCTAssertTrue(hasUpdateConsumerBeenDeallocated)
    }

}

//final class QuickScreenTests: QuickSpec {
//
//    override func spec() {
//        describe("Screen") {
//
//            context("after `startUpdating` has been called") {
//
//                context("when a `UIScreen.brightnessDidChangeNotification` notification is fired from the backing object") {
//                    beforeEach {
//                        mockBackingData.brightness = 0.53
//                        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification, object: mockBackingData)
//                    }
//
//                    it("should notify update consumers synchronously") {
//                        expect(updateConsumer.hasBeenCalled).to(beTrue())
//                    }
//
//                    it("should pass the new value to the update listener") {
//                        expect(updateConsumer.latestValues).to(containElementSatisfying({ value in
//                            guard let value = value as? PercentValue else { return false }
//                            guard value.displayName == screen.brightness.displayName else { return false }
//                            return value.value == mockBackingData.brightness.native
//                        }))
//                    }
//                }
//
//                context("when a `UIScreen.brightnessDidChangeNotification` notification is fired from an object that isn't the backing object") {
//                    it("should not notify update consumers") {
//                        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification, object: UIScreen.main)
//
//                        expect(updateConsumer.hasBeenCalled).to(beFalse())
//                    }
//                }
//
//            }
//        }
//    }
//
//}
#endif
