import Foundation
import CoreLocation

/**
 A `NumberFormatter` with the `negativeSuffix` and `positiveSuffix`
 properties set to "x"
 */
public final class ScaleFormatter: NumberFormatter {

    public override init() {
        super.init()

        negativeSuffix = "x"
        positiveSuffix = "x"
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
