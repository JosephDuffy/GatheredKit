#if canImport(NetworkExtension)
import Combine
import GatheredKit
import NetworkExtension

/// A wrapper around `NEHotspotNetwork`.
@available(iOS 9, watchOS 7, macCatalyst 14, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
public final class WiFi: Source {
    public let availability: SourceAvailability = .available

    public let id: SourceIdentifier

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    @BasicProperty
    public private(set) var ssid: String

    @BasicProperty
    public private(set) var bssid: String

    /// The `NEHotspotNetwork` this `Network` represents.
    public let hostspotNetwork: NEHotspotNetwork

    public var allProperties: [any Property] {
        [
            $ssid,
            $bssid,
        ]
    }

    public init(hostspotNetwork: NEHotspotNetwork) {
        id = SourceIdentifier(
            sourceKind: .wifi,
            instanceIdentifier: hostspotNetwork.bssid,
            isTransient: false
        )
        self.hostspotNetwork = hostspotNetwork

        _ssid = .init(
            id: id.identifierForChildPropertyWithId("ssid"),
            value: hostspotNetwork.ssid
        )
        _bssid = .init(
            id: id.identifierForChildPropertyWithId("bssid"),
            value: hostspotNetwork.bssid
        )

        // There are other properties, such as `didAutoJoin` and
        // `signalStrength`, which seem to return default values (`false` and
        // `0`) when permission is provided via precise WiFi location.
    }
}
#endif
