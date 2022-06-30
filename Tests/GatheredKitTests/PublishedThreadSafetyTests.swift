import Combine
import Foundation
import XCTest

final class PublishedThreadSafetyTests: XCTestCase {
    func testSettingValueFromMultipleThreads() {
        let object = ObjectWithPublished()

        let iterations = 1000
        let completesIterationExpectation = expectation(description: "Completes iterations")
        completesIterationExpectation.expectedFulfillmentCount = iterations
        let receivesNewValueExpectation = expectation(description: "Received new value")
        receivesNewValueExpectation.expectedFulfillmentCount = iterations

        var cancellables: Set<AnyCancellable> = []

        object
            .$property
            .dropFirst()
            .sink { _ in
                receivesNewValueExpectation.fulfill()
            }
            .store(in: &cancellables)

        DispatchQueue.concurrentPerform(iterations: iterations) { iteration in
            object.property = iteration
            completesIterationExpectation.fulfill()
        }

        waitForExpectations(timeout: 1)
    }
}

private final class ObjectWithPublished: @unchecked Sendable {
    @Published
    var property: Int?
}
