import XCTest
import GatheredKit

final class OptionalPropertyTests: XCTestCase {

    func testNilValue() {
        let property = OptionalProperty<String, Formatter>(displayName: "Test Value")
        XCTAssertEqual(property.displayName, "Test Value")
        XCTAssertNil(property.value)
        XCTAssertNil(property.formattedValue)
    }

    func testNonNilValue() {
        let property = OptionalProperty<String, Formatter>(displayName: "Test Value", value: "test")
        XCTAssertEqual(property.displayName, "Test Value")
        XCTAssertEqual(property.value, "test")
        XCTAssertNil(property.formattedValue)
    }

}
