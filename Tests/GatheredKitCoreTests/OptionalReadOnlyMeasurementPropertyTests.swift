import XCTest
import GatheredKitCore

final class OptionalReadOnlyMeasurementPropertyTests: XCTestCase {

    func testNilValue() {
        let property = OptionalReadOnlyMeasurementProperty<UnitFrequency>(displayName: "Test", value: nil)
        XCTAssertNil(property.formattedValue)
    }

    func testNonNilValue() {
        let metadata = OptionalReadOnlyMeasurementProperty<UnitFrequency>(displayName: "Test", value: 5)
        let formattedString = metadata.formatter.string(for: metadata.value)
        XCTAssertNotNil(formattedString)
    }

}
