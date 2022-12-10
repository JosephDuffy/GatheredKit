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
        XCTAssertEqual(screen.reportedResolution.size, uiScreen.bounds.size)
        XCTAssertEqual(screen.nativeResolution.size, uiScreen.nativeBounds.size)
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
        uiScreen.scale = 1
        uiScreen.nativeScale = 1
        uiScreen.bounds.size = CGSize(width: 1920, height: 1080)
        uiScreen.nativeBounds.size = CGSize(width: 1920, height: 1080)
        let notificationCenter = NotificationCenter()
        let screen = Screen(screen: uiScreen, notificationCenter: notificationCenter)

        screen.startUpdating()

        let reportedResolutionExpectation = expectation(
            description: "Subscriber should be called with updated reported resolution"
        )
        let reportedResolutionCancellable = screen.$reportedResolution.snapshotsPublisher.dropFirst().sink { reportedResolution in
            XCTAssertEqual(reportedResolution.value.size, uiScreen.bounds.size)
            reportedResolutionExpectation.fulfill()
        }

        let nativeResolutionExpectation = expectation(
            description: "Subscriber should be called with updated native resolution"
        )
        let nativeResolutionCancellable = screen.$nativeResolution.snapshotsPublisher.dropFirst().sink { nativeResolution in
            XCTAssertEqual(nativeResolution.value.size, uiScreen.nativeBounds.size)
            nativeResolutionExpectation.fulfill()
        }

        let reportedScaleExpectation = expectation(
            description: "Subscriber should be called with updated reported scale"
        )
        let reportedScaleCancellable = screen.$reportedScale.snapshotsPublisher.dropFirst().sink { reportedScale in
            XCTAssertEqual(reportedScale.value, uiScreen.scale)
            reportedScaleExpectation.fulfill()
        }

        let nativeScaleExpectation = expectation(
            description: "Subscriber should be called with updated native scale"
        )
        let nativeScaleCancellable = screen.$nativeScale.snapshotsPublisher.dropFirst().sink { nativeScale in
            XCTAssertEqual(nativeScale.value, uiScreen.nativeScale)
            nativeScaleExpectation.fulfill()
        }

        uiScreen.bounds.size = CGSize(width: 3008, height: 1692)
        uiScreen.nativeBounds.size = CGSize(width: 6016, height: 3384)
        uiScreen.scale = 2
        uiScreen.nativeScale = 2
        notificationCenter.post(name: UIScreen.modeDidChangeNotification, object: uiScreen)

        waitForExpectations(timeout: 1)

        _ = reportedResolutionCancellable
        _ = nativeResolutionCancellable
        _ = reportedScaleCancellable
        _ = nativeScaleCancellable
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
