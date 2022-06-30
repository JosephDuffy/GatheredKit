#if canImport(CoreMotion)
import Combine
import CoreMotion
import Foundation
import GatheredKit

@available(macOS, unavailable)
public final class Altimeter: UpdatingSource, Controllable, @unchecked Sendable {
    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let name = "Altimeter"

    @Published
    public private(set) var availability: SourceAvailability

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    @Published
    public private(set) var isUpdating: Bool = false

    public var isUpdatingPublisher: AnyPublisher<Bool, Never> {
        $isUpdating.eraseToAnyPublisher()
    }

    @OptionalLengthProperty
    public private(set) var relativeAltitude: Measurement<UnitLength>?

    /// This property is only available on iOS 15 and watchOS 8 or later. On
    /// prior versions this will always be `nil`.
    @OptionalCMAbsoluteAltitudeDataProperty
    public private(set) var absoluteAltitude: CMAbsoluteAltitudeDataShim?

    @OptionalPressureProperty
    public private(set) var pressure: Measurement<UnitPressure>?

    public var allProperties: [AnyProperty] {
        if #available(iOS 15, watchOS 8, *) {
            return [$relativeAltitude, $absoluteAltitude, $pressure]
        } else {
            return [$relativeAltitude, $pressure]
        }
    }

    private let altimeter: CMAltimeter

    private var state: State = .notMonitoring {
        didSet {
            switch state {
            case .monitoring:
                isUpdating = true
            case .notMonitoring:
                isUpdating = false
            }
        }
    }

    private var propertiesCancellables: [AnyCancellable] = []

    public init(altimeter: CMAltimeter = CMAltimeter()) {
        self.altimeter = altimeter
        availability = CMAltimeter.availability
        _relativeAltitude = .meters(displayName: "Relative Altitude")
        _absoluteAltitude = .init(displayName: "Absolute Altitude")
        _pressure = .kilopascals(displayName: "Pressure")

        propertiesCancellables = allProperties.map { property in
            property
                .typeErasedSnapshotPublisher
                .sink { [weak property, eventsSubject] snapshot in
                    guard let property = property else { return }
                    eventsSubject.send(.propertyUpdated(property: property, snapshot: snapshot))
                }
        }
    }

    deinit {
        altimeter.stopRelativeAltitudeUpdates()
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        let availability = CMAltimeter.availability

        if availability != self.availability {
            self.availability = availability
            eventsSubject.send(.availabilityUpdated(availability))
        }

        switch availability {
        case .available:
            break
        case .permissionDenied:
            eventsSubject.send(.failedToStart(error: .permissionDenied))
            return
        case .requiresPermissionsPrompt:
            break
        case .restricted:
            eventsSubject.send(.failedToStart(error: .restricted))
            return
        case .unavailable:
            eventsSubject.send(.failedToStart(error: .unavailable))
            return
        }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "GatheredKit Altimeter Updates"

        startRelativeAltitudeUpdates(to: updatesQueue)

        let availabilityAfterStarting = CMAltimeter.availability

        if availabilityAfterStarting != self.availability {
            self.availability = availabilityAfterStarting
            eventsSubject.send(.availabilityUpdated(availabilityAfterStarting))
        }

        state = .monitoring(updatesQueue: updatesQueue)
        eventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        guard case .monitoring = state else { return }
        altimeter.stopRelativeAltitudeUpdates()
        state = .notMonitoring
        eventsSubject.send(.stoppedUpdating())
    }

    public func resetRelativeAltitude() {
        guard case .monitoring(let updatesQueue) = state else { return }
        altimeter.stopRelativeAltitudeUpdates()
        startRelativeAltitudeUpdates(to: updatesQueue)
    }

    private func startRelativeAltitudeUpdates(to queue: OperationQueue) {
        altimeter.startRelativeAltitudeUpdates(to: queue) { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                self.altimeter.stopRelativeAltitudeUpdates()
                self.eventsSubject.send(.stoppedUpdating(error: error))
                self.state = .notMonitoring
                return
            }
            guard let data = data else { return }

            self._relativeAltitude.updateMeasuredValue(data.relativeAltitude.doubleValue)
            self._pressure.updateMeasuredValue(data.pressure.doubleValue)
        }

        if #available(iOS 15, watchOS 8, *), !ProcessInfo.processInfo.isMacCatalystApp {
            if CMAltimeter.isAbsoluteAltitudeAvailable() {
                switch CMAltimeter.authorizationStatus() {
                case .authorized, .notDetermined:
                    // If the authorization status is not determined making this
                    // call with trigger the permission dialogue.
                    altimeter.startAbsoluteAltitudeUpdates(to: queue) { [weak self] data, error in
                        guard let self = self else { return }

                        self.absoluteAltitude = data.map(CMAbsoluteAltitudeDataShim.init(cmAbsoluteAltitudeData:))
                        self._absoluteAltitude.error = error

                        let availability = CMAltimeter.availability

                        if availability != self.availability {
                            self.availability = availability
                            self.eventsSubject.send(.availabilityUpdated(availability))
                        }
                    }
                case .denied:
                    _absoluteAltitude.error = DeniedError()
                case .restricted:
                    _absoluteAltitude.error = RestrictedError()
                @unknown default:
                    break
                }
            } else {
                _absoluteAltitude.error = UnsupportedError()
            }
        }
    }
}

public struct UnsupportedError: LocalizedError {
    public var errorDescription: String? {
        "Unsupported"
    }
}

public struct DeniedError: LocalizedError {
    public var errorDescription: String? {
        "Permission Denied"
    }
}

public struct RestrictedError: LocalizedError {
    public var errorDescription: String? {
        "Restricted Denied"
    }
}

@available(macOS, unavailable)
extension CMAltimeter {
    fileprivate static var availability: SourceAvailability {
        if CMAltimeter.isRelativeAltitudeAvailable() {
            return .available
        }

        if #available(iOS 15, watchOS 8, *), !ProcessInfo.processInfo.isMacCatalystApp {
            if CMAltimeter.isAbsoluteAltitudeAvailable() {
                switch CMAltimeter.authorizationStatus() {
                case .authorized:
                    return .available
                case .notDetermined:
                    return .requiresPermissionsPrompt
                case .denied:
                    return .permissionDenied
                case .restricted:
                    return .restricted
                @unknown default:
                    return .unavailable
                }
            }
        }

        return .unavailable
    }
}
#endif
