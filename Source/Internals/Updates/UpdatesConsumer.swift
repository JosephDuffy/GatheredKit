import Foundation

public protocol UpdatesConsumer: class {
    func comsume(values: [AnyValue], from source: Source)
}
