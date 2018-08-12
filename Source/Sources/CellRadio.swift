import Foundation
import CoreTelephony

public final class CellRadio: BaseSource, Source, Controllable, ValuesProvider {

    private enum State {
        case notMonitoring
        case monitoring(telephonyInfo: CTTelephonyNetworkInfo, notificationObserver: NSObjectProtocol, updatesQueue: OperationQueue)
    }

    public static var availability: SourceAvailability {
        var isAvailable = false

        var ifAddressPointer: UnsafeMutablePointer<ifaddrs>?

        guard getifaddrs(&ifAddressPointer) == 0 else { return .unavailable }

        defer {
            freeifaddrs(ifAddressPointer)
        }

        guard let firstAddress = ifAddressPointer else { return .unavailable }

        for ifAddress in sequence(first: firstAddress, next: { $0.pointee.ifa_next }) {
            guard let name = String(validatingUTF8: ifAddress.pointee.ifa_name) else { continue }

            if name == "pdp_ip0" {
                return .available
            }
        }

        return .unavailable
    }

    public static var name = "Cell Radio"

    /// A boolean indicating if the screen is monitoring for brightness changes
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public private(set) var carrier: CarrierValue
    public private(set) var radioAccessTechnology: GenericUnitlessValue<String?>

    public var allValues: [Value] {
        return [
            carrier,
            radioAccessTechnology,
        ]
    }

    private let device: UIDevice = .current

    private var state: State = .notMonitoring

    public override init() {
        carrier = CarrierValue()
        radioAccessTechnology = GenericUnitlessValue(displayName: "Radio Access Technology")
    }

    deinit {
        stopUpdating()
    }

    public func startUpdating() {
        let telephonyInfo = CTTelephonyNetworkInfo()

        telephonyInfo.subscriberCellularProviderDidUpdateNotifier = { [weak self] carrier in
            guard let `self` = self else { return }
            self.carrier.update(backingValue: carrier)
            self.notifyListenersPropertyValuesUpdated()
        }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "uk.co.josephduffy.GatheredKit Cell Radio Access Technology Updates"

        let notificationObserver = NotificationCenter.default.addObserver(forName: .CTRadioAccessTechnologyDidChange, object: device, queue: updatesQueue) { [weak self, weak telephonyInfo] _ in
            guard let `self` = self else { return }
            guard let telephonyInfo = telephonyInfo else { return }

            self.update(radioAccessTechnology: telephonyInfo.currentRadioAccessTechnology)
            self.notifyListenersPropertyValuesUpdated()
        }

        update(radioAccessTechnology: telephonyInfo.currentRadioAccessTechnology)

        state = .monitoring(telephonyInfo: telephonyInfo, notificationObserver: notificationObserver, updatesQueue: updatesQueue)
    }

    public func stopUpdating() {
        guard case .monitoring(_, let notificationObserver, _) = state else { return }

        NotificationCenter.default.removeObserver(notificationObserver, name: .CTRadioAccessTechnologyDidChange, object: device)

        state = .notMonitoring
    }

    private func update(radioAccessTechnology: String?) {
        let formattedValue: String?

        switch radioAccessTechnology {
        case CTRadioAccessTechnologyGPRS:
            formattedValue = "GPRS"
        case CTRadioAccessTechnologyEdge:
            formattedValue = "Edge"
        case CTRadioAccessTechnologyWCDMA:
            formattedValue = "3G (WCDMA)"
        case CTRadioAccessTechnologyHSDPA:
            formattedValue = "3G (HSDPA)"
        case CTRadioAccessTechnologyHSUPA:
            formattedValue = "3G (HSUPA)"
        case CTRadioAccessTechnologyCDMA1x:
            formattedValue = "CDMA1x"
        case CTRadioAccessTechnologyCDMAEVDORev0:
            formattedValue = "3G (EVDO Rev-0)"
        case CTRadioAccessTechnologyCDMAEVDORevA:
            formattedValue = "3G (EVDO Rev-A)"
        case CTRadioAccessTechnologyCDMAEVDORevB:
            formattedValue = "3G (EVDO ReV-B)"
        case CTRadioAccessTechnologyeHRPD:
            formattedValue = "3G (HRPD)"
        case CTRadioAccessTechnologyLTE:
            formattedValue = "4G (LTE)"
        default:
            formattedValue = nil
        }

        self.radioAccessTechnology.update(backingValue: radioAccessTechnology, formattedValue: formattedValue)
    }

}
