#if os(iOS) || os(watchOS)
import CoreMotion

private let deviceBootTime = Date(timeIntervalSinceNow: -ProcessInfo.processInfo.systemUptime)

extension CMLogItem {
    internal var date: Date {
        Date(timeInterval: timestamp, since: deviceBootTime)
    }
}
#endif
