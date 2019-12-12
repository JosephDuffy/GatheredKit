import XCTest
import GatheredKit

final class OptionalMeasurementPropertyTests: XCTestCase {

    func testNilValue() {
        let property = OptionalMeasurementProperty<UnitFrequency>(displayName: "Test", value: nil)
        XCTAssertNil(property.formattedValue)
    }

    func testNonNilValue() {
        let property = OptionalMeasurementProperty<UnitFrequency>(displayName: "Test", value: 5)
        let formattedString = property.formatter.string(for: property.value)
        XCTAssertNotNil(formattedString)
    }

}
