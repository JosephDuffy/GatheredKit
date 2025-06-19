import Combine
import Foundation

/// An object that can provide data from a specific source on the device
@MainActor
public protocol Source: PropertiesProviding {
    /// The availability of the source
    var availability: SourceAvailability { get }

    var id: SourceIdentifier { get }
}
