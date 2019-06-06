import Foundation
import CoreLocation

/**
 A `NumberFormatter` with the `numberStyle` set to `percent`
 */
public final class PercentFormatter: NumberFormatter {
    
    public override init() {
        super.init()
        
        numberStyle = .percent
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
