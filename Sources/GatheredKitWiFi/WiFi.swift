#if canImport(NetworkExtension)
@preconcurrency import Combine
import GatheredKit
import NetworkExtension

/// A wrapper around `NEHotspotNetwork`.
@available(iOS 9, watchOS 7, macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
public final class WiFi: Source, @unchecked Sendable {
    public let availability: SourceAvailability = .available

    public let name: String

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    @StringProperty
    public private(set) var ssid: String

    @StringProperty
    public private(set) var bssid: String

    /// The `NEHotspotNetwork` this `Network` represents.
    public let hostspotNetwork: NEHotspotNetwork

    public var allProperties: [AnyProperty] {
        [
            $ssid,
            $bssid,
        ]
    }

    public init(hostspotNetwork: NEHotspotNetwork) {
        name = hostspotNetwork.ssid
        self.hostspotNetwork = hostspotNetwork

        _ssid = .init(displayName: "SSID", value: hostspotNetwork.ssid)
        _bssid = .init(displayName: "BSSID", value: hostspotNetwork.bssid)

        // There are other properties, such as `didAutoJoin` and
        // `signalStrength`, which seem to return default values (`false` and
        // `0`) when permission is provided via precise WiFi location.
    }
}
#endif
