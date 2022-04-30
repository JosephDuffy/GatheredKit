#if os(iOS) || os(tvOS)
@testable import GatheredKitScreen
import GatheredKitTestHelpers
import UIKit
import XCTest

final class ScreenTests: XCTestCase {
    func testDefaultInitialiser() {
        let screen = Screen()
        XCTAssertEqual(screen.uiScreen, UIScreen.main)
    }

    func testValues() {
        let uiScreen = UIScreen.main
        let screen = Screen(screen: uiScreen)
        XCTAssertEqual(screen.reportedResolution, uiScreen.bounds.size)
        XCTAssertEqual(screen.nativeResolution, uiScreen.nativeBounds.size)
        XCTAssertEqual(screen.reportedScale, uiScreen.scale)
        XCTAssertEqual(screen.nativeScale, uiScreen.nativeScale)
        #if os(iOS)
        XCTAssertEqual(screen.brightness, uiScreen.brightness)
        #endif
    }

    func testStartUpdating() {
        let notificationCenter = MockNotificationCenter()
        let uiScreen = UIScreen.main
        let screen = Screen(screen: uiScreen, notificationCenter: notificationCenter)
        let expectation = XCTestExpectation(description: "Should publish a start updating event")
        expectation.assertForOverFulfill = true
        expectation.expectedFulfillmentCount = 1
        let cancellable = screen.eventsPublisher.sink { event in
            defer {
                expectation.fulfill()
            }

            switch event {
            case .startedUpdating:
                break
            default:
                XCTFail("Should only publish the `startedUpdating")
            }
        }
        _ = cancellable
        screen.startUpdating()

        XCTAssertTrue(screen.isUpdating)

        #if os(iOS)
        XCTAssertEqual(notificationCenter.addObserverCallCount, 2)
        XCTAssertTrue(
            notificationCenter.addObserverNames.contains(UIScreen.brightnessDidChangeNotification))
        XCTAssertTrue(
            notificationCenter.addObserverNames.contains(UIScreen.modeDidChangeNotification))
        #elseif os(tvOS)
        XCTAssertEqual(notificationCenter.addObserverCallCount, 1)
        XCTAssertTrue(
            notificationCenter.addObserverNames.contains(UIScreen.modeDidChangeNotification))
        #endif
        XCTAssertEqual(
            Set(notificationCenter.addObserverParameters.map { $0.object as? UIScreen }),
            Set([uiScreen])
        )

        screen.startUpdating()

        XCTAssertTrue(screen.isUpdating)
        #if os(iOS)
        XCTAssertEqual(notificationCenter.addObserverCallCount, 2)
        #elseif os(tvOS)
        XCTAssertEqual(notificationCenter.addObserverCallCount, 1)
        #endif

        wait(for: [expectation], timeout: 0.01)
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
        let uiScreen = UIScreen.main
        let screen = Screen(screen: uiScreen, notificationCenter: notificationCenter)
        let startUpdatingEventExpectation = XCTestExpectation(
            description: "Should publish a start updating event")
        startUpdatingEventExpectation.assertForOverFulfill = true
        startUpdatingEventExpectation.expectedFulfillmentCount = 1
        let stopUpdatingEventExpectation = XCTestExpectation(
            description: "Should publish a stop updating event")
        stopUpdatingEventExpectation.assertForOverFulfill = true
        stopUpdatingEventExpectation.expectedFulfillmentCount = 1
        let cancellable = screen.eventsPublisher.sink { event in
            switch event {
            case .startedUpdating:
                startUpdatingEventExpectation.fulfill()
            case .stoppedUpdating:
                stopUpdatingEventExpectation.fulfill()
            default:
                XCTFail("Should never send \(event) event")
            }
        }
        // Shutup Xcode
        _ = cancellable
        screen.startUpdating()

        XCTAssertTrue(screen.isUpdating)

        screen.stopUpdating()

        XCTAssertFalse(screen.isUpdating)

        #if os(iOS)
        XCTAssertEqual(notificationCenter.addObserverCallCount, 2)
        XCTAssertTrue(
            notificationCenter.addObserverNames.contains(UIScreen.brightnessDidChangeNotification))
        XCTAssertTrue(
            notificationCenter.addObserverNames.contains(UIScreen.modeDidChangeNotification))
        XCTAssertEqual(notificationCenter.removeObserverParameters.count, 2)
        XCTAssertTrue(
            notificationCenter.removeObserverNames.contains(
                UIScreen.brightnessDidChangeNotification))
        XCTAssertTrue(
            notificationCenter.removeObserverNames.contains(UIScreen.modeDidChangeNotification))
        #elseif os(tvOS)
        XCTAssertEqual(notificationCenter.addObserverCallCount, 1)
        XCTAssertTrue(
            notificationCenter.addObserverNames.contains(UIScreen.modeDidChangeNotification))
        XCTAssertEqual(notificationCenter.removeObserverParameters.count, 1)
        XCTAssertTrue(
            notificationCenter.removeObserverNames.contains(UIScreen.modeDidChangeNotification))
        #endif

        XCTAssertEqual(
            Set(notificationCenter.addObserverParameters.map { $0.object as? UIScreen }),
            Set([uiScreen])
        )
        XCTAssertEqual(
            Set(notificationCenter.removeObserverParameters.map { $0.object as? UIScreen }),
            Set([uiScreen])
        )

        wait(for: [startUpdatingEventExpectation], timeout: 0.01)
    }

    func testNotificationFromScreen() {
        let uiScreen = MockScreen()
        let notificationCenter = NotificationCenter()
        let screen = Screen(screen: uiScreen, notificationCenter: notificationCenter)

        let reportedResolutionExpectation = XCTestExpectation(
            description: "Subscriber should be called with updated reported resolution")
        reportedResolutionExpectation.expectedFulfillmentCount = 2
        reportedResolutionExpectation.assertForOverFulfill = true
        let reportedResolutionCancellable = screen.$reportedResolution.snapshotsPublisher.sink { reportedResolution in
                reportedResolutionExpectation.fulfill()
                XCTAssertEqual(reportedResolution.value, uiScreen.bounds.size)
            }

        let nativeResolutionExpectation = XCTestExpectation(
            description: "Subscriber should be called with updated native resolution")
        nativeResolutionExpectation.expectedFulfillmentCount = 2
        nativeResolutionExpectation.assertForOverFulfill = true
        let nativeResolutionCancellable = screen.$nativeResolution.snapshotsPublisher.sink
            {
                nativeResolution in
                nativeResolutionExpectation.fulfill()
                XCTAssertEqual(nativeResolution.value, uiScreen.nativeBounds.size)
            }

        let reportedScaleExpectation = XCTestExpectation(
            description: "Subscriber should be called with updated reported scale")
        reportedScaleExpectation.expectedFulfillmentCount = 2
        reportedScaleExpectation.assertForOverFulfill = true
        let reportedScaleCancellable = screen.$reportedScale.snapshotsPublisher.sink {
            reportedScale in
            reportedScaleExpectation.fulfill()
            XCTAssertEqual(reportedScale.value, uiScreen.scale)
        }

        let nativeScaleExpectation = XCTestExpectation(
            description: "Subscriber should be called with updated native scale")
        nativeScaleExpectation.expectedFulfillmentCount = 2
        nativeScaleExpectation.assertForOverFulfill = true
        let nativeScaleCancellable = screen.$nativeScale.snapshotsPublisher.sink {
            nativeScale in
            nativeScaleExpectation.fulfill()
            XCTAssertEqual(nativeScale.value, uiScreen.nativeScale)
        }

        screen.startUpdating()

        uiScreen.bounds.size = CGSize(width: 3008, height: 1692)
        uiScreen.nativeBounds.size = CGSize(width: 6016, height: 3384)
        uiScreen.scale = 2
        uiScreen.nativeScale = 2
        notificationCenter.post(name: UIScreen.modeDidChangeNotification, object: uiScreen)
        XCTAssertEqual(screen.reportedResolution, uiScreen.bounds.size)
        XCTAssertEqual(screen.nativeResolution, uiScreen.nativeBounds.size)
        XCTAssertEqual(screen.reportedScale, uiScreen.scale)
        XCTAssertEqual(screen.nativeScale, uiScreen.nativeScale)

        reportedResolutionCancellable.cancel()
        nativeResolutionCancellable.cancel()
        reportedScaleCancellable.cancel()
        nativeScaleCancellable.cancel()

        wait(
            for: [
                reportedResolutionExpectation,
                nativeResolutionExpectation,
                reportedScaleExpectation,
                nativeScaleExpectation,
            ],
            timeout: 0.01
        )
    }

    #if os(iOS)
    func testBrightnessUpdate() {
        let uiScreen = MockScreen()
        uiScreen.forceEqualToMain = true
        uiScreen.brightness = 0.1
        let notificationCenter = NotificationCenter()
        let screen = Screen(screen: uiScreen, notificationCenter: notificationCenter)

        let brightnessExpectation = XCTestExpectation(
            description: "Subscriber should be called when brightness updates")
        brightnessExpectation.expectedFulfillmentCount = 2

        let brightnessCancellable = screen.$brightness.snapshotsPublisher.sink {
            brightness in
            brightnessExpectation.fulfill()
            XCTAssertEqual(brightness.value, uiScreen.brightness)
        }

        screen.startUpdating()

        uiScreen.brightness = 0.54
        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification, object: uiScreen)
        XCTAssertEqual(screen.brightness, uiScreen.brightness)

        brightnessCancellable.cancel()

        uiScreen.brightness = 0.63
        notificationCenter.post(name: UIScreen.brightnessDidChangeNotification, object: uiScreen)
        XCTAssertEqual(screen.brightness, uiScreen.brightness)

        wait(
            for: [
                brightnessExpectation,
            ],
            timeout: 0.1
        )
    }

    func testBrightnessUpdateFromDifferentScreen() {
        let mockScreen = MockScreen()
        let notificationCenter = NotificationCenter()
        let screen = Screen(screen: mockScreen, notificationCenter: notificationCenter)
        screen.startUpdating()

        let expectation = XCTestExpectation(description: "Subscriber should not be called")
        expectation.expectedFulfillmentCount = 1
        expectation.assertForOverFulfill = true
        let cancellable = screen.$brightness.snapshotsPublisher.sink { _ in
            expectation.fulfill()
        }
        _ = cancellable

        mockScreen.brightness = 0.53
        notificationCenter.post(
            name: UIScreen.brightnessDidChangeNotification, object: UIScreen.main
        )

        wait(for: [expectation], timeout: 0.1)
    }
    #endif
}

#endif
