import XCTest
@testable
import GatheredKit

final class UnitMagneticFieldTests: XCTestCase {

    func testMicroTesla() {
        let microTesla = UnitMagneticField.microTesla
        XCTAssertEqual(microTesla.converter.baseUnitValue(fromValue: 1000), 1)
    }

}
