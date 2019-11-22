#if os(iOS)
import CoreMotion

private var deviceBootTime: Date = {
    return Date().addingTimeInterval(-ProcessInfo.processInfo.systemUptime)
}()

extension CMLogItem {
    
    internal var date: Date {
        return Date(timeInterval: timestamp, since: deviceBootTime)
    }
    
}
#endif
