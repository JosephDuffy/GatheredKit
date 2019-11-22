import Foundation

extension OperationQueue {
    
    internal convenience init(name: String? = nil) {
        self.init()
        
        self.name = name
    }
    
}
