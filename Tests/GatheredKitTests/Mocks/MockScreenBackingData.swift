#if canImport(UIKit)
import UIKit
import Quick
import Nimble

@testable
import GatheredKit

final class MockScreenBackingData: ScreenBackingData {

    var bounds = CGRect(x: 0, y: 0, width: 320, height: 480)

    var scale: CGFloat = 2

    var nativeBounds = CGRect(x: 0, y: 0, width: 640, height: 960)

    var nativeScale: CGFloat = 2

    var brightness: CGFloat = 0.76

    init() {}

}
#endif
