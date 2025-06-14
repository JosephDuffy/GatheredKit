import GatheredKitSubscriptions
import XCTest

final class PropertySubscriptionsStorageTests: XCTestCase {
    func testAccessAcrossTasks() async {
        let storage = PropertySubscriptionsStorage<Int, Never>()

        let taskCount = 1000
        let createsSubscriptionsExpectation = expectation(description: "Creates all subscriptions")
        createsSubscriptionsExpectation.expectedFulfillmentCount = taskCount
        let receivesValueExpectation = expectation(description: "All subscriptions should receive value")
        receivesValueExpectation.expectedFulfillmentCount = taskCount
        let publishedValue = 123456

        for _ in 0..<taskCount {
            Task.detached {
                let subscription = storage.makeValueSubscription()
                createsSubscriptionsExpectation.fulfill()
                for await value in subscription.values {
                    XCTAssertEqual(value, publishedValue)
                    receivesValueExpectation.fulfill()
                    break
                }
            }
        }

        wait(for: [createsSubscriptionsExpectation], timeout: 1)

        storage.notifySubscribersOfValue(publishedValue)

        await waitForExpectations(timeout: 1)
    }

    func testDeinitCancelling() async {
        let storage = PropertySubscriptionsStorage<Int, Never>()
        var subscription: PropertySubscription<Int, Never>? = storage.makeValueSubscription()

        let valuesStream = subscription!.values
        let valuesStreamReceivesFirstValue = expectation(description: "Values stream receives first value")
        let valuesStreamEndsExpectation = expectation(description: "Subscription's values stream ends")

        Task.detached {
            for await _ in valuesStream {
                valuesStreamReceivesFirstValue.fulfill()
            }

            valuesStreamEndsExpectation.fulfill()
        }

        subscription?.handleValue(1)

        wait(for: [valuesStreamReceivesFirstValue], timeout: 0.1)

        subscription = nil

        wait(for: [valuesStreamEndsExpectation], timeout: 0.1)

        let valuesStreamEndsAfterCancellationExpectation = expectation(description: "Subscription's values stream ends immediately after cancellation")
        Task.detached {
            for await _ in valuesStream {
                break
            }

            valuesStreamEndsAfterCancellationExpectation.fulfill()
        }

        wait(for: [valuesStreamEndsAfterCancellationExpectation], timeout: 0.1)
    }

    func testManualCancelling() async {
        let storage = PropertySubscriptionsStorage<Int, Never>()
        let subscription = storage.makeValueSubscription()

        let valuesStream = subscription.values
        let valuesStreamReceivesFirstValue = expectation(description: "Values stream receives first value")
        let valuesStreamEndsExpectation = expectation(description: "Subscription's values stream ends")

        Task.detached {
            for await _ in valuesStream {
                valuesStreamReceivesFirstValue.fulfill()
            }

            valuesStreamEndsExpectation.fulfill()
        }

        subscription.handleValue(1)

        wait(for: [valuesStreamReceivesFirstValue], timeout: 0.1)

        subscription.cancel()

        wait(for: [valuesStreamEndsExpectation], timeout: 0.1)

        let valuesStreamEndsAfterCancellationExpectation = expectation(description: "Subscription's values stream ends immediately after cancellation")
        Task.detached {
            for await _ in valuesStream {
                break
            }

            valuesStreamEndsAfterCancellationExpectation.fulfill()
        }

        wait(for: [valuesStreamEndsAfterCancellationExpectation], timeout: 0.1)
    }
}
