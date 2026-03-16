import GatheredKit
import XCTest

final class SourceProviderIdentifierTests: XCTestCase {
    func testLosslessStringConvertibleConformance() throws {
        let identifierString = "TestsNamespace.TestSource/test-instance~"
        let sourceProviderIdentifier = try XCTUnwrap(SourceProviderIdentifier(identifierString))
        XCTAssertEqual(sourceProviderIdentifier.namespace, "TestsNamespace")
        XCTAssertEqual(sourceProviderIdentifier.sourceKind.rawValue, "TestSource")
        XCTAssertEqual(sourceProviderIdentifier.instanceIdentifier?.id, "test-instance")
        XCTAssertTrue(sourceProviderIdentifier.instanceIdentifier?.isEphemeral ?? false)
        XCTAssertEqual(sourceProviderIdentifier.description, identifierString)
    }

    func testLosslessStringConvertibleConformanceWithoutInstanceIdentifier() throws {
        let identifierString = "TestsNamespace.TestSource"
        let sourceProviderIdentifier = try XCTUnwrap(SourceProviderIdentifier(identifierString))
        XCTAssertEqual(sourceProviderIdentifier.namespace, "TestsNamespace")
        XCTAssertEqual(sourceProviderIdentifier.sourceKind.rawValue, "TestSource")
        XCTAssertNil(sourceProviderIdentifier.instanceIdentifier)
        XCTAssertEqual(sourceProviderIdentifier.description, identifierString)
    }

    func testLosslessStringConvertibleConformanceWithSeparatorsInIdentifiers() throws {
        let identifierString = "TestsNamespace.TestSource.ExtraIdentifier/test-instance/extra-instance~"
        let sourceProviderIdentifier = try XCTUnwrap(SourceProviderIdentifier(identifierString))
        XCTAssertEqual(sourceProviderIdentifier.namespace, "TestsNamespace")
        XCTAssertEqual(sourceProviderIdentifier.sourceKind.rawValue, "TestSource.ExtraIdentifier")
        XCTAssertEqual(sourceProviderIdentifier.instanceIdentifier?.id, "test-instance/extra-instance")
        XCTAssertTrue(sourceProviderIdentifier.instanceIdentifier?.isEphemeral ?? false)
        XCTAssertEqual(sourceProviderIdentifier.description, identifierString)
    }

    func testLosslessStringConvertibleConformanceWithEmptyIdentifierString() {
        XCTAssertNil(SourceProviderIdentifier(""))
    }

    func testLosslessStringConvertibleConformanceWithoutNamespaceSeparator() {
        XCTAssertNil(SourceProviderIdentifier("TestsNamespace"))
    }
}
