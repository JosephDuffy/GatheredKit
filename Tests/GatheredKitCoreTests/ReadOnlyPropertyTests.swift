import XCTest
import GatheredKitCore
import GatheredKitTestHelpers

final class ReadOnlyPropertyTests: XCTestCase {

    func testNilValue() {
        let metadata = ReadOnlyProperty<String?, MockFormatter>(displayName: "Test Value")
        XCTAssertEqual(metadata.displayName, "Test Value")
        XCTAssertNil(metadata.value)
        XCTAssertNil(metadata.formattedValue)
    }

    func testNonNilValue() {
        let property = ReadOnlyProperty<String?, MockFormatter>(displayName: "Test Value", value: "test")
        XCTAssertEqual(property.displayName, "Test Value")
        XCTAssertEqual(property.value, "test")
        XCTAssertNil(property.formattedValue)
    }

}
