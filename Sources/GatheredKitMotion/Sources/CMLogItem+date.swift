#if os(iOS) || os(watchOS)
import CoreMotion

private var deviceBootTime: Date = {
    Date().addingTimeInterval(-ProcessInfo.processInfo.systemUptime)
}()

extension CMLogItem {
    internal var date: Date {
        Date(timeInterval: timestamp, since: deviceBootTime)
    }
}
#endif
