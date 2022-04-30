#if os(iOS) || os(watchOS)
import Combine
import CoreMotion
import Foundation
import GatheredKit

public final class Altimeter: UpdatingSource, Controllable, ActionProvider {
    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public let name = "Altimeter"

    public private(set) var availability: SourceAvailability

    public var eventsPublisher: AnyPublisher<SourceEvent, Never> {
        eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<SourceEvent, Never>()

    public private(set) var isUpdating: Bool = false

    @OptionalLengthProperty
    public private(set) var relativeAltitude: Measurement<UnitLength>?
    @OptionalPressureProperty
    public private(set) var pressure: Measurement<UnitPressure>?

    public var allProperties: [AnyProperty] {
        [$relativeAltitude, $pressure]
    }

    public var actions: [Action] {
        [
            Action(
                title: "Reset Altitude", isAvailable: isUpdating,
                perform: { [weak self] in
                    guard let self = self else { return }
                    guard self.isUpdating else { return }
                    self.stopUpdating()
                    self.startUpdating()
                }
            ),
        ]
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

        let oldAvailability = availability
        availability = CMAltimeter.availability

        if availability != oldAvailability {
            eventsSubject.send(.availabilityUpdated(availability))
        }

        switch availability {
        case .available:
            break
        case .permissionDenied:
            eventsSubject.send(.failedToStart(error: .permissionDenied))
            return
        case .requiresPermissionsPrompt:
            // Perhaps it will ask the user when `startRelativeAltitudeUpdates` is called?
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

        altimeter.startRelativeAltitudeUpdates(to: updatesQueue) { [weak self] data, error in
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

        state = .monitoring(updatesQueue: updatesQueue)
        eventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        guard case .monitoring = state else { return }
        altimeter.stopRelativeAltitudeUpdates()
        state = .notMonitoring
        eventsSubject.send(.stoppedUpdating())
    }
}

extension CMAltimeter {
    fileprivate static var availability: SourceAvailability {
        guard isRelativeAltitudeAvailable() else {
            return .unavailable
        }

        let authorizationStatus = authorizationStatus()
        switch authorizationStatus {
        case .authorized:
            return .available
        case .denied:
            return .permissionDenied
        case .notDetermined:
            return .requiresPermissionsPrompt
        case .restricted:
            return .restricted
        @unknown default:
            return .unavailable
        }
    }
}

#endif
