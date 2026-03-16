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
    public let hotspotNetwork: NEHotspotNetwork

    public var allProperties: [any Property] {
        [
            $ssid,
            $bssid,
        ]
    }

    public init(hotspotNetwork: NEHotspotNetwork) {
        id = SourceIdentifier(
            sourceKind: .wifi,
            instanceIdentifier: hotspotNetwork.bssid,
            isEphemeral: false
        )
        self.hotspotNetwork = hotspotNetwork

        _ssid = .init(
            id: id.identifierForChildPropertyWithId("ssid"),
            value: hotspotNetwork.ssid
        )
        _bssid = .init(
            id: id.identifierForChildPropertyWithId("bssid"),
            value: hotspotNetwork.bssid
        )

        // There are other properties, such as `didAutoJoin` and
        // `signalStrength`, which seem to return default values (`false` and
        // `0`) when permission is provided via precise WiFi location.
    }
}
#endif
