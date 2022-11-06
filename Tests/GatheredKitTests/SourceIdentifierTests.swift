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

    func testLosslessStringConvertibleConformanceWithoutDeviceId() throws {
        let identifierString = "TestsNamespace.TestSource|test-instance"
        let sourceIdentifier = try XCTUnwrap(SourceIdentifier(identifierString))
        XCTAssertEqual(sourceIdentifier.namespace, "TestsNamespace")
        XCTAssertEqual(sourceIdentifier.sourceKind.rawValue, "TestSource")
        XCTAssertEqual(sourceIdentifier.instanceIdentifier?.id, "test-instance")
        XCTAssertFalse(sourceIdentifier.instanceIdentifier?.isTransient ?? true)
        XCTAssertNil(sourceIdentifier.deviceIdentifier)
        XCTAssertEqual(sourceIdentifier.description, identifierString)
    }

    func testLosslessStringConvertibleConformanceWithoutInstanceIdentifier() throws {
        let identifierString = "TestsNamespace.TestSource@device-id"
        let sourceIdentifier = try XCTUnwrap(SourceIdentifier(identifierString))
        XCTAssertEqual(sourceIdentifier.namespace, "TestsNamespace")
        XCTAssertEqual(sourceIdentifier.sourceKind.rawValue, "TestSource")
        XCTAssertNil(sourceIdentifier.instanceIdentifier)
        XCTAssertEqual(sourceIdentifier.deviceIdentifier, "device-id")
        XCTAssertEqual(sourceIdentifier.description, identifierString)
    }

    func testLosslessStringConvertibleConformanceWithoutInstanceIdentifierOrDeviceId() throws {
        let identifierString = "TestsNamespace.TestSource"
        let sourceIdentifier = try XCTUnwrap(SourceIdentifier(identifierString))
        XCTAssertEqual(sourceIdentifier.namespace, "TestsNamespace")
        XCTAssertEqual(sourceIdentifier.sourceKind.rawValue, "TestSource")
        XCTAssertNil(sourceIdentifier.instanceIdentifier)
        XCTAssertNil(sourceIdentifier.deviceIdentifier)
        XCTAssertEqual(sourceIdentifier.description, identifierString)
    }
}
