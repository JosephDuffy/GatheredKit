import Foundation

/**
 An object that can provide data from a specific source on the device
 */
public protocol Source: class, ValuesProvider {

    /// The availability of the source
    static var availability: SourceAvailability { get }

    /// A boolean indicating if the source is currently performing automatic updates
    var isUpdating: Bool { get }

    /// A user-friendly name that represents the source, e.g. "Location", "Device Attitude"
    var displayName: String { get }

    /// Creates a new instance of the source
    init()

}
