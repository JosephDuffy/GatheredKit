import GatheredKit

internal final class MockUpdateConsumer: UpdatesConsumer {
    
    internal private(set) var latestParameters: (values: [AnyValue], sender: AnyObject)?
    internal var latestValues: [AnyValue]? {
        return latestParameters?.values
    }
    internal var latestSource: AnyObject? {
        return latestParameters?.sender
    }
    internal var hasBeenCalled: Bool {
        return latestParameters != nil
    }
    
    func comsume(values: [AnyValue], sender: AnyObject) {
        latestParameters = (values, sender)
    }
    
}
