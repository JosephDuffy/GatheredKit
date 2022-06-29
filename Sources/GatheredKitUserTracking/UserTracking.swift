#if canImport(AdSupport)
import AdSupport
import AppTrackingTransparency
import Combine
import GatheredKit

/// A source for requesting and reading the advertising identifier associated
/// the device.
///
/// - Note: This does not conform to ``UpdatesProviding`` because the source can
/// never be listening for updates; the authorisation status will only update in
/// response to the user allowing or denying access. If the user changes the
/// authorisation (e.g. through the Settings app) while the app is running the
/// app will be terminated.
@available(macOS 11, iOS 14, tvOS 14, *)
public final class UserTracking: Source {
    private enum State {
        case notMonitoring
        case monitoring(observations: [NSKeyValueObservation])
    }

    public let availability: SourceAvailability = .available

    public let name: String

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    @Published
    public private(set) var isUpdating: Bool = false

    public var isUpdatingPublisher: AnyPublisher<Bool, Never> {
        $isUpdating.eraseToAnyPublisher()
    }

    public let identifierManager: ASIdentifierManager

    @BasicProperty<ATTrackingManager.AuthorizationStatus, UserTrackingAuthorizationStatusFormatter>
    public private(set) var trackingAuthorizationStatus: ATTrackingManager.AuthorizationStatus

    @BasicProperty<UUID, AdvertisingIdentifierFormatter>
    @available(macOS, deprecated, message: "Advertising identifier will be all zeros")
    public private(set) var advertisingIdentifier: UUID

    public var allProperties: [AnyProperty] {
        [
            $trackingAuthorizationStatus,
            $advertisingIdentifier,
        ]
    }

    public init(identifierManager: ASIdentifierManager = .shared()) {
        self.identifierManager = identifierManager
        name = "User Tracking"
        _trackingAuthorizationStatus = .init(
            displayName: "Authorisation Status",
            value: ATTrackingManager.trackingAuthorizationStatus
        )
        _advertisingIdentifier = .init(
            displayName: "Advertising Identifier",
            value: identifierManager.advertisingIdentifier
        )
    }

    public func requestAuthorization() {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }

        ATTrackingManager.requestTrackingAuthorization { status in
            self.trackingAuthorizationStatus = status
            #if os(iOS) || os(tvOS)
            self.advertisingIdentifier = self.identifierManager.advertisingIdentifier
            #endif
        }
    }
}
#endif
