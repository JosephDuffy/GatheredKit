import GatheredKit

internal final class MockUpdateConsumer: UpdatesConsumer {
    
    internal private(set) var latestParameters: (values: [AnyValue], source: Source)?
    internal var latestValues: [AnyValue]? {
        return latestParameters?.values
    }
    internal var latestSource: Source? {
        return latestParameters?.source
    }
    internal var hasBeenCalled: Bool {
        return latestParameters != nil
    }
    
    func comsume(values: [AnyValue], from source: Source) {
        latestParameters = (values, source)
    }
    
}
