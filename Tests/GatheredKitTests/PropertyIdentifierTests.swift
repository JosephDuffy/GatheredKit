import GatheredKit
import XCTest

final class PropertyIdentifierTests: XCTestCase {
    func testLosslessStringConvertibleConformance() throws {
        let identifierString = "TestsNamespace.TestSource|test-instance@device-id/property-1/property-2/final-property"
        let propertyIdentifier = try XCTUnwrap(PropertyIdentifier(identifierString))
        let sourceIdentifier = propertyIdentifier.sourceIdentifier()
        XCTAssertEqual(sourceIdentifier.namespace, "TestsNamespace")
        XCTAssertEqual(sourceIdentifier.sourceKind.rawValue, "TestSource")
        XCTAssertEqual(sourceIdentifier.instanceIdentifier?.id, "test-instance")
        XCTAssertFalse(sourceIdentifier.instanceIdentifier?.isTransient ?? true)
        XCTAssertEqual(sourceIdentifier.deviceIdentifier, "device-id")
        XCTAssertEqual(propertyIdentifier.description, identifierString)
    }
}
