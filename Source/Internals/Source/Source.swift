/**
 An object that can provide data from a specific source on the device
 */
public protocol Source: class, ValuesProvider {

    /// A closure that will be called with the latest values
    typealias UpdateListener = (_ latestValues: [AnyValue]) -> Void

    /// The availability of the source
    static var availability: SourceAvailability { get }

    /// A user-friendly name that represents the source, e.g. "Location", "Device Attitude"
    static var name: String { get }

    /// Creates a new instance of the source
    init()

}
