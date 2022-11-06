import GatheredKit
import XCTest

final class SourceIdentifierTests: XCTestCase {
    func testLosslessStringConvertibleConformance() throws {
        let identifierString = "TestsNamespace.TestSource|test-instance~@device-id"
        let sourceIdentifier = try XCTUnwrap(SourceIdentifier(identifierString))
        XCTAssertEqual(sourceIdentifier.namespace, "TestsNamespace")
        XCTAssertEqual(sourceIdentifier.sourceKind.rawValue, "TestSource")
        XCTAssertEqual(sourceIdentifier.instanceIdentifier?.id, "test-instance")
        XCTAssertTrue(sourceIdentifier.instanceIdentifier?.isTransient ?? false)
        XCTAssertEqual(sourceIdentifier.deviceIdentifier, "device-id")
        XCTAssertEqual(sourceIdentifier.description, identifierString)
    }
}
