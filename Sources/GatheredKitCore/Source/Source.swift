import Foundation
import Combine

/**
 An object that can provide data from a specific source on the device
 */
public protocol Source: PropertiesProvider {

    /// The availability of the source
    var availability: SourceAvailability { get }

    /// A user-friendly name that represents the source, e.g. "Location", "Device Attitude"
    var name: String { get }

}
