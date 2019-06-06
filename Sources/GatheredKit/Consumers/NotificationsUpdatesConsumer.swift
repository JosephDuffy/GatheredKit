import Foundation

public final class NotificationConsumer<ConsumedValue, ConsumedSender>: Consumer {
    
    public static var valueUserInfoKey: String {
        return "value"
    }
    
    private let notificationName: Notification.Name
    private let notificationCenter: NotificationCenter
    
    public init(notificationName: Notification.Name, notificationCenter: NotificationCenter = .default) {
        self.notificationName = notificationName
        self.notificationCenter = notificationCenter
    }
    
    public func consume(value: ConsumedValue, sender: ConsumedSender) {
        notificationCenter.post(
            name: notificationName,
            object: sender,
            userInfo: [
                NotificationConsumer<ConsumedValue, ConsumedSender>.valueUserInfoKey: value,
            ]
        )
    }
    
}
