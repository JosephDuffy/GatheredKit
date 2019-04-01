import Foundation

public final class NotificationsUpdatesConsumer: UpdatesConsumer {
    
    static let valuesUserInfoKey = "values"
    
    private let notificationName: Notification.Name
    private let notificationCenter: NotificationCenter
    
    public init(notificationName: Notification.Name, notificationCenter: NotificationCenter = .default) {
        self.notificationName = notificationName
        self.notificationCenter = notificationCenter
    }
    
    public func comsume(values: [AnyValue], from source: Source) {
        notificationCenter.post(
            name: notificationName,
            object: source,
            userInfo: [
                NotificationsUpdatesConsumer.valuesUserInfoKey: values,
            ]
        )
    }
    
}
