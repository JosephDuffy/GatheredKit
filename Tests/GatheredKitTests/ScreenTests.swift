#if canImport(UIKit)
import UIKit
import XCTest
@testable
import GatheredKit

final class ScreenTests: XCTestCase {

    func testDefaultInitialiser() {
        let screen = Screen()
        XCTAssertEqual(screen.uiScreen, UIScreen.main)
    }

    func testValues() {
        let mock = MockScreen()
        let screen = Screen(screen: mock)
        XCTAssertEqual(screen.reportedResolution.value, mock.bounds.size)
        XCTAssertEqual(screen.nativeResolution.value, mock.nativeBounds.size)
        XCTAssertEqual(screen.reportedScale.value, mock.scale)
        XCTAssertEqual(screen.nativeScale.value, mock.nativeScale)
        XCTAssertEqual(screen.brightness.value, mock.brightness)
    }

    func testStartUpdating() {
        let notificationCenter = MockNotificationCenter()
        let screen = Screen(screen: UIScreen.main, notificationCenter: notificationCenter)
        let expectation = XCTestExpectation(description: "Should not publish updates")
        expectation.isInverted = true
        let cancellable = screen.publisher.sink { _ in
            expectation.fulfill()
        }
        // Shutup Xcode
        _ = cancellable
        screen.startUpdating()

        XCTAssertTrue(screen.isUpdating)

        XCTAssertEqual(notificationCenter.addObserverCallCount, 2)
        XCTAssertTrue(notificationCenter.addObserverNames.contains(UIScreen.brightnessDidChangeNotification))
        XCTAssertTrue(notificationCenter.addObserverNames.contains(UIScreen.modeDidChangeNotification))
        XCTAssertEqual(notificationCenter.addObserverParameters.map { $0.object as? UIScreen }, [UIScreen.main, UIScreen.main])

        screen.startUpdating()

        XCTAssertTrue(screen.isUpdating)
        XCTAssertEqual(notificationCenter.addObserverCallCount, 2)

        wait(for: [expectation], timeout: 1)
    }

    func testStopUpdatingWhenNotUpdating() {
        let notificationCenter = MockNotificationCenter()
        let screen = Screen(screen: UIScreen.main, notificationCenter: notificationCenter)
        screen.stopUpdating()
        XCTAssertFalse(screen.isUpdating)
        XCTAssertTrue(notificationCenter.addObserverParameters.isEmpty)
        XCTAssertTrue(notificationCenter.removeObserverParameters.isEmpty)
    }

    func testStopUpdatingWhenUpdating() {
        let notificationCenter = MockNotificationCenter()
        let screen = Screen(screen: UIScreen.main, notificationCenter: notificationCenter)
        let expectation = XCTestExpectation(description: "Should not publish updates")
        expectation.isInverted = true
        let cancellable = screen.publisher.sink { _ in
            expectation.fulfill()
        }
        // Shutup Xcode
        _ = cancellable
        screen.startUpdating()

        XCTAssertTrue(screen.isUpdating)

        screen.stopUpdating()

        XCTAssertFalse(screen.isUpdating)

        XCTAssertEqual(notificationCenter.addObserverCallCount, 2)
        XCTAssertTrue(notificationCenter.addObserverNames.contains(UIScreen.brightnessDidChangeNotification))
        XCTAssertTrue(notificationCenter.addObserverNames.contains(UIScreen.modeDidChangeNotification))
        XCTAssertEqual(notificationCenter.addObserverParameters.map { $0.object as? UIScreen }, [UIScreen.main, UIScreen.main])
        XCTAssertEqual(notificationCenter.removeObserverParameters.count, 2)
        XCTAssertTrue(notificationCenter.removeObserverNames.contains(UIScreen.brightnessDidChangeNotification))
        XCTAssertTrue(notificationCenter.removeObserverNames.contains(UIScreen.modeDidChangeNotification))
        XCTAssertEqual(notificationCenter.removeObserverParameters.map { $0.object as? UIScreen }, [UIScreen.main, UIScreen.main])

        wait(for: [expectation], timeout: 1)
    }

    func testNotificationFromScreen() {
        let uiScreen = MockScreen()
        let notificationCenter = NotificationCenter()
        let screen = Screen(screen: uiScreen, notificationCenter: notificationCenter)

        let brightnessExpectation = XCTestExpectation(description: "Subscriber should be called with updated brightness")
        brightnessExpectation.expectedFulfillmentCount = 1
        brightnessExpectation.assertForOverFulfill = true
        let brightnessCancellable = screen.brightness.publisher.sink { brightness in
            brightnessExpectation.fulfill()
            XCTAssertEqual(screen.brightness.value, uiScreen.brightness)
        }

        let reportedResolutionExpectation = XCTestExpectation(description: "Subscriber should be called with updated reported resolution")
        reportedResolutionExpectation.expectedFulfillmentCount = 1
        reportedResolutionExpectation.assertForOverFulfill = true
        let reportedResolutionCancellable = screen.reportedResolution.publisher.sink { reportedResolution in
            reportedResolutionExpectation.fulfill()
            XCTAssertEqual(screen.reportedResolution.value, uiScreen.bounds.size)
        }

        let nativeResolutionExpectation = XCTestExpectation(description: "Subscriber should be called with updated native resolution")
        nativeResolutionExpectation.expectedFulfillmentCount = 1
        nativeResolutionExpectation.assertForOverFulfill = true
        let nativeResolutionCancellable = screen.nativeResolution.publisher.sink { nativeResolution in
            nativeResolutionExpectation.fulfill()
            XCTAssertEqual(screen.nativeResolution.value, uiScreen.nativeBounds.size)
        }

        let reportedScaleExpectation = XCTestExpectation(description: "Subscriber should be called with updated reported scale")
        reportedScaleExpectation.expectedFulfillmentCount = 1
        reportedScaleExpectation.assertForOverFulfill = true
        let reportedScaleCancellable = screen.reportedScale.publisher.sink { reportedScale in
            reportedScaleExpectation.fulfill()
            XCTAssertEqual(screen.reportedScale.value, uiScreen.scale)
        }

        let nativeScaleExpectation = XCTestExpectation(description: "Subscriber should be called with updated native scale")
        nativeScaleExpectation.expectedFulfillmentCount = 1
        nativeScaleExpectation.assertForOverFulfill = true
        let nativeScaleCancellable = screen.nativeScale.publisher.sink { nativeResolution in
            nativeScaleExpectation.fulfill()
            XCTAssertEqual(screen.nativeScale.value, uiScreen.nativeScale)
        }

        screen.startUpdating()

        XCTAssertEqual(screen.brightness.value, uiScreen.brightness)
        XCTAssertEqual(screen.reportedResolution.value, uiScreen.bounds.size)
        XCTAssertEqual(screen.nativeResolution.value, uiScreen.nativeBounds.size)
        XCTAssertEqual(screen.reportedScale.value, uiScreen.scale)
        XCTAssertEqual(screen.nativeScale.value, uiScreen.nativeScale)

        uiScreen.brightness = 0.53
        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification, object: uiScreen)
        XCTAssertEqual(screen.brightness.value, uiScreen.brightness)

        uiScreen.bounds.size = CGSize(width: 3008, height: 1692)
        uiScreen.nativeBounds.size = CGSize(width: 6016, height: 3384)
        uiScreen.scale = 2
        uiScreen.nativeScale = 2
        notificationCenter.post(name: UIScreen.modeDidChangeNotification, object: uiScreen)
        XCTAssertEqual(screen.reportedResolution.value, uiScreen.bounds.size)
        XCTAssertEqual(screen.nativeResolution.value, uiScreen.nativeBounds.size)
        XCTAssertEqual(screen.reportedScale.value, uiScreen.scale)
        XCTAssertEqual(screen.nativeScale.value, uiScreen.nativeScale)

        // Ensure closures are not
        brightnessCancellable.cancel()
        reportedResolutionCancellable.cancel()
        nativeResolutionCancellable.cancel()
        reportedScaleCancellable.cancel()
        nativeScaleCancellable.cancel()

        uiScreen.brightness = 0.63
        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification, object: uiScreen)

        wait(for: [brightnessExpectation], timeout: 1)
    }

    func testBrightnessUpdateFromDifferentScreen() {
        let mockBackingData = MockScreen()
        let notificationCenter = NotificationCenter()
        let screen = Screen(screen: mockBackingData, notificationCenter: notificationCenter)

        let expectation = XCTestExpectation(description: "Subscriber should not be called")
        expectation.isInverted = true
        let cancellable = screen.brightness.publisher.sink { _ in
            expectation.fulfill()
        }
        screen.startUpdating()

        mockBackingData.brightness = 0.53
        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification, object: UIScreen.main)

        wait(for: [expectation], timeout: 1)
        cancellable.cancel()
    }

}

#endif
