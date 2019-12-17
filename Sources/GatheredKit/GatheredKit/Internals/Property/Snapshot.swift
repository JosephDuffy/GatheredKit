import Foundation

public protocol Snapshot {
    var date: Date { get }
}

internal protocol ValueProvider {
    var valueAsAny: Any? { get }
}
