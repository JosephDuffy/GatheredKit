import Foundation

public class BaseSource: NSObject {

    private var updateListeners = NSHashTable<SourceUpdateListenerWrapper>.weakObjects()

    override init() {
        guard type(of: self) != BaseSource.self else {
            fatalError("BaseSource must be subclassed")
        }

        super.init()
    }

    public func addUpdateListener(_ updateListener: @escaping Source.UpdateListener) -> AnyObject {
        let observer = SourceUpdateListenerWrapper(updateListener: updateListener)
        updateListeners.add(observer)
        return observer
    }

    internal func notifyUpdateListeners(latestPropertyValues: [AnyValue]) {
        if Thread.isMainThread {
            updateListeners.allObjects.forEach { $0.updateListener(latestPropertyValues) }
        } else {
            DispatchQueue.main.async {
                self.updateListeners.allObjects.forEach { $0.updateListener(latestPropertyValues) }
            }
        }
    }

}

extension Source where Self: BaseSource {

    internal func notifyListenersPropertyValuesUpdated() {
        notifyUpdateListeners(latestPropertyValues: allValues)
    }

}