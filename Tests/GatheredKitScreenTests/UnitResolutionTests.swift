import GatheredKitScreen
import XCTest

final class UnitResolutionTests: XCTestCase {
    func testPointsConversion() {
        let pointUnit = UnitResolution.points(screenScale: 3)
        let measurement = Measurement(value: 100, unit: pointUnit)
        XCTAssertEqual(measurement.converted(to: .pixels).value, 300)
    }
}
