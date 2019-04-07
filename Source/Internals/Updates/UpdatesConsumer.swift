import Foundation

public protocol UpdatesConsumer: class {
    func comsume(values: [AnyValue], sender: AnyObject)
}
