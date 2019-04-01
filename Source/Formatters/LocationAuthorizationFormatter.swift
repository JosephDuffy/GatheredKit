import Foundation
import CoreLocation

public final class LocationAuthorizationFormatter: Formatter {
    
    public func string(for status: CLAuthorizationStatus) -> String {
        switch status {
        case .authorizedAlways:
            return "Always"
        case .authorizedWhenInUse:
            return "When In Use"
        case .denied:
            return "Denied"
        case .notDetermined:
            return "Not Determined"
        case .restricted:
            return "Restricted"
        }
    }

    public override func string(for obj: Any?) -> String? {
        guard let status = obj as? CLAuthorizationStatus else { return nil }
        return string(for: status)
    }

}
