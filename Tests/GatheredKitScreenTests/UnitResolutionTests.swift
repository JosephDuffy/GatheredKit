import GatheredKitScreen
import XCTest

final class UnitResolutionTests: XCTestCase {
    func testPointsConversion() {
        let pointUnit = UnitResolution.points(pixelsPerPoint: 3)
        let measurement = Measurement(value: 300, unit: pointUnit)
        XCTAssertEqual(measurement.converted(to: .pixels).value, 100)
    }
}
