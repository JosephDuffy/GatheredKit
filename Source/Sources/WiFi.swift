import Foundation
import CoreFoundation
import SystemConfiguration.CaptiveNetwork

public final class WiFi: BaseSource, ControllableSource, ManuallyUpdatableSource {

    private enum State {
        case notMonitoring
        case monitoring(reachabilityReference: SCNetworkReachability, updatesQueue: DispatchQueue)
    }

    public static var availability: SourceAvailability = .available

    public static var displayName = "Wi-Fi"

    /// A boolean indicating if the screen is monitoring for brightness changes
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public var lanIP: GenericValue<String?, None>
    public var ssid: GenericValue<String?, None>
    public var bssid: GenericValue<String?, None>

    public var allValues: [AnyValue] {
        return [
            lanIP.asAny(),
            ssid.asAny(),
            bssid.asAny(),
        ]
    }

    private var state: State = .notMonitoring

    public override init() {
        lanIP = GenericValue(name: "LAN IP")
        ssid = GenericValue(name: "SSID")
        bssid = GenericValue(name: "BSSID")
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating() {
        defer {
            updateProperties()
        }

        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)

        guard let reachabilityReference = SCNetworkReachabilityCreateWithAddress(nil, &zeroAddress) else {
            return
        }

        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged<WiFi>.passUnretained(self).toOpaque())

        guard
            SCNetworkReachabilitySetCallback(
                reachabilityReference,
                { (reachability: SCNetworkReachability, flags: SCNetworkReachabilityFlags, info: UnsafeMutableRawPointer?) in
                    guard let pointerToSelf = info else { return }

                    let `self` = Unmanaged<WiFi>.fromOpaque(pointerToSelf).takeUnretainedValue()
                    self.updateProperties()
                },
                &context
            )
        else {
            return
        }

        let updatesQueue = DispatchQueue(label: "uk.co.josephduffy.GatheredKit Wi-Fi Updates")

        guard SCNetworkReachabilitySetDispatchQueue(reachabilityReference, updatesQueue) else {
            return
        }

        state = .monitoring(reachabilityReference: reachabilityReference, updatesQueue: updatesQueue)
    }

    public func stopUpdating() {
        guard case .monitoring(let reachabilityReference, _) = state else { return }

        SCNetworkReachabilitySetCallback(reachabilityReference, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachabilityReference, nil)

        state = .notMonitoring
    }

    @discardableResult
    public func updateProperties() -> [AnyValue] {
        guard let interfaces = CNCopySupportedInterfaces() as? [CFString] else {
            print("Failed to cast interfaces to CFString array")
            return allValues
        }

        defer {
            notifyListenersPropertyValuesUpdated()
        }

        if let interface = interfaces.last {
            let lanIP = getWiFiAddress(interfaceName: interface as String)
            self.lanIP.update(backingValue: lanIP)

            if let interfaceData = CNCopyCurrentNetworkInfo(interface) as? [CFString: Any] {
                if let ssidString = interfaceData[kCNNetworkInfoKeySSID] as? String {
                    ssid.update(backingValue: ssidString)
                }
                if let bssidString = interfaceData[kCNNetworkInfoKeyBSSID] as? String {
                    let displayValue = bssidString.split(separator: ":").map { $0.uppercased() }.map { $0.count == 1 ? "0" + $0 : $0 }.joined(separator: ":")
                    bssid.update(backingValue: bssidString, formattedValue: displayValue)
                }
            } else if lanIP != nil, #available(iOS 12.0, *) {
                print("Failed to get interface data for \(interface). Have you added the 'Access WiFi Information' entitlement?")
                ssid.update(backingValue: nil, formattedValue: "Unknown")
                bssid.update(backingValue: nil, formattedValue: "Unknown")
            } else if lanIP == nil {
                self.lanIP.update(backingValue: nil, formattedValue: "Not Connected")
                ssid.update(backingValue: nil, formattedValue: "Not Connected")
                bssid.update(backingValue: nil, formattedValue: "Not Connected")
            }
        } else {
            lanIP.update(backingValue: nil, formattedValue: "Not Connected")
            ssid.update(backingValue: nil, formattedValue: "Not Connected")
            bssid.update(backingValue: nil, formattedValue: "Not Connected")
        }

        return allValues
    }

    // From https://stackoverflow.com/a/30754194/657676
    private func getWiFiAddress(interfaceName: String) -> String? {
        var address: String?

        var ifAddress: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&ifAddress) == 0 else { return nil }
        guard let firstAddr = ifAddress else { return nil }

        defer {
            freeifaddrs(ifAddress)
        }

        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            let addrFamily = interface.ifa_addr.pointee.sa_family

            // TODO: Add IPV6 support via AF_INET6
            guard addrFamily == UInt8(AF_INET) else { continue }

            let name = String(cString: interface.ifa_name)
            guard name == interfaceName else { continue}

            // Convert interface address to a human readable string:
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, socklen_t(0), NI_NUMERICHOST)
            address = String(cString: hostname)
            break
        }

        return address
    }

}
