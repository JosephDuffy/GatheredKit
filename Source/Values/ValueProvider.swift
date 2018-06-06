import Foundation

public protocol ValueProvider {

    var latestValues: [AnyValue] { get }

}
