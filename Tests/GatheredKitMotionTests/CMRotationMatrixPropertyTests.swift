#if os(iOS) || os(watchOS)
import CoreMotion
import GatheredKitMotion
import XCTest

final class CMRotationMatrixPropertyTests: XCTestCase {
    func testFormatter() {
        let rotationMatrix = CMRotationMatrix(
            m11: 11,
            m12: 12,
            m13: 13,
            m21: 21,
            m22: 22,
            m23: 23,
            m31: 31,
            m32: 32,
            m33: 33
        )
        let property = CMRotationMatrixProperty(
            displayName: "Rotation Matrix",
            value: rotationMatrix
        )
        XCTAssertNotNil(property.formattedValue)
    }
}
#endif
