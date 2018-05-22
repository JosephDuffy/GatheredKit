
/**
 An object that can provide data from a specific source on the device
 */
public protocol Source: class {

    typealias UpdateListener = (_ data: [AnySourceProperty]) -> Void

    static var availability: SourceAvailability { get }

    var latestPropertyValues: [AnySourceProperty] { get }

    init()

    func addUpdateListener(_ updateListener: @escaping UpdateListener) -> AnyObject
    
}
