import GatheredKit

internal final class MockValuesConsumer<ConsumedValue, ConsumedSender>: Consumer {
    
    internal private(set) var latestValues: ConsumedValue?
    
    internal var deinitHandler: (() -> Void)?
    
    internal var hasBeenCalled: Bool {
        return latestValues != nil
    }
    
    deinit {
        deinitHandler?()
    }
    
    internal func consume(value: ConsumedValue, sender: ConsumedSender) {
        latestValues = value
    }
    
}
