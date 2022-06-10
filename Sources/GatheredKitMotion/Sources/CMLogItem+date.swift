import CoreMotion

private let deviceBootTime = Date(timeIntervalSinceNow: -ProcessInfo.processInfo.systemUptime)

@available(macOS, unavailable)
extension CMLogItem {
    internal var date: Date {
        Date(timeInterval: timestamp, since: deviceBootTime)
    }
}
