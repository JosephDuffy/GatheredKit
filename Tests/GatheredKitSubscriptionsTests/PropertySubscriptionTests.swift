import GatheredKitSubscriptions
import XCTest

final class PropertySubscriptionTests: XCTestCase {
    func testAccessAcrossTasks() async {
        let subscription = PropertySubscription<Int, Never>(cancelationHandler: {})

        let taskCount = 1000
        let createsSubscriptionsExpectation = expectation(description: "Creates all subscriptions")
        createsSubscriptionsExpectation.expectedFulfillmentCount = taskCount
        let receivesValueExpectation = expectation(description: "All subscriptions should receive value")
        receivesValueExpectation.expectedFulfillmentCount = taskCount
        let publishedValue = 123456

        for _ in 0..<taskCount {
            Task.detached {
                createsSubscriptionsExpectation.fulfill()
                for await value in subscription.values {
                    XCTAssertEqual(value, publishedValue)
                    receivesValueExpectation.fulfill()
                    break
                }
            }
        }

        wait(for: [createsSubscriptionsExpectation], timeout: 1)

        subscription.handleValue(publishedValue)

        await waitForExpectations(timeout: 1)
    }

    func testCancellingAcrossTasks() async {
        let cancelCallCount = 1000

        let cancelationHandlerCalledExpectation = expectation(description: "Calls cancelation handler once")
        let subscription = PropertySubscription<Int, Never>(cancelationHandler: {
            cancelationHandlerCalledExpectation.fulfill()
        })

        let callsCancelExpectation = expectation(description: "Call `cancel` on subscription")
        callsCancelExpectation.expectedFulfillmentCount = cancelCallCount
        for _ in 0..<cancelCallCount {
            Task.detached {
                subscription.cancel()
                callsCancelExpectation.fulfill()
            }
        }

        await waitForExpectations(timeout: 1)

        // Don't let subscription be cancelled prematurely due to deinit
        _ = subscription
    }

    func testCancelationIsSync() {
        var hasCanceled = false
        let subscription = PropertySubscription<Int, Never>(cancelationHandler: {
            hasCanceled = true
        })
        subscription.cancel()
        XCTAssertTrue(hasCanceled, "Cancelation closure should be called synchronously when `cancel` function is called")
    }

    func testHandlingValueAfterCancelation() async {
        let subscription = PropertySubscription<Int, Never>(cancelationHandler: {})

        let receivesValueExpectation = expectation(description: "New value should not be send to subscribers")
        receivesValueExpectation.isInverted = true
        Task.detached {
            for await _ in subscription.values {
                receivesValueExpectation.fulfill()
                break
            }
        }

        subscription.cancel()
        subscription.handleValue(123)

        await waitForExpectations(timeout: 0.1)

        // Don't let subscription be cancelled prematurely due to deinit
        _ = subscription
    }
}
