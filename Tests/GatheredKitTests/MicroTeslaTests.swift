import GatheredKit
import XCTest

final class MicroTeslaTests: XCTestCase {

    func testMicroTesla() {
        let microTesla = UnitMagneticField.microTesla
        XCTAssertEqual(microTesla.converter.baseUnitValue(fromValue: 1000), 1)
    }

}
