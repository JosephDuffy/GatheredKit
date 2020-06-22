#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine
import GatheredKitCore

public final class Altimeter: Source, Controllable, ActionProvider {

    private enum State {
        case notMonitoring
        case monitoring(altimeter: CMAltimeter, updatesQueue: OperationQueue)
    }

    public let name = "Altimeter"

    public private(set) var availability: SourceAvailability

    @available(iOS 13.0, *)
    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return eventsSubject.eraseToAnyPublisher()
    }

    @available(iOS 13.0, *)
    private var eventsSubject: PassthroughSubject<ControllableEvent, ControllableError> {
        return _eventsSubject as! PassthroughSubject<ControllableEvent, ControllableError>
    }

    private lazy var _eventsSubject: Any = {
        if #available(iOS 13.0, *) {
            return PassthroughSubject<ControllableEvent, ControllableError>()
        } else {
            fatalError()
        }
    }()

    public private(set) var isUpdating: Bool = false

    @OptionalLengthProperty
    public private(set) var relativeAltitude: Measurement<UnitLength>?
    @OptionalPressureProperty
    public private(set) var pressure: Measurement<UnitPressure>?

    public var allProperties: [AnyProperty] {
        return [$relativeAltitude, $pressure]
    }

    public var actions: [Action] {
        return [
            Action(title: "Reset Altitude", isAvailable: isUpdating, perform: { [weak self] in
                guard let self = self else { return }
                guard self.isUpdating else { return }
                self.stopUpdating()
                self.startUpdating()
            }),
        ]
    }

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

    public init() {
        availability = CMAltimeter.availability
        _relativeAltitude = .meters(displayName: "Relative Altitude")
        _pressure = .kilopascals(displayName: "Pressure")
    }

    public func startUpdating() {
        guard !isUpdating else { return }

        let oldAvailability = availability
        availability = CMAltimeter.availability

        if availability != oldAvailability {
            if #available(iOS 13.0, *) {
                eventsSubject.send(.availabilityUpdated(availability))
            } else {
                // Fallback on earlier versions
            }
        }

        switch availability {
        case .available:
            break
        case .permissionDenied:
            if #available(iOS 13.0, *) {
                eventsSubject.send(completion: .failure(.permissionDenied))
            } else {
                // Fallback on earlier versions
            }
            return
        case .requiresPermissionsPrompt:
            // Perhaps it will ask the user when `startRelativeAltitudeUpdates` is called?
            break
        case .restricted:
            if #available(iOS 13.0, *) {
                eventsSubject.send(completion: .failure(.restricted))
            } else {
                // Fallback on earlier versions
            }
            return
        case .unavailable:
            if #available(iOS 13.0, *) {
                eventsSubject.send(completion: .failure(.unavailable))
            } else {
                // Fallback on earlier versions
            }
            return
        }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "GatheredKit Altimeter Updates"
        let altimeter = CMAltimeter()

        altimeter.startRelativeAltitudeUpdates(to: updatesQueue) { [weak self, weak altimeter] data, error in
            guard let self = self else { return }
            if let error = error {
                altimeter?.stopRelativeAltitudeUpdates()
                if #available(iOS 13.0, *) {
                    self.eventsSubject.send(completion: .failure(.other(error)))
                } else {
                    // Fallback on earlier versions
                }
                self.state = .notMonitoring
                return
            }
            guard let data = data else { return }
            self._relativeAltitude.updateValueIfDifferent(measuredValue: data.relativeAltitude.doubleValue)
            self._pressure.updateValueIfDifferent(measuredValue: data.pressure.doubleValue)
        }

        state = .monitoring(altimeter: altimeter, updatesQueue: updatesQueue)
        if #available(iOS 13.0, *) {
            eventsSubject.send(.startedUpdating)
        } else {
            // Fallback on earlier versions
        }
    }

    public func stopUpdating() {
        guard case .monitoring(let altimeter, _) = state else { return }
        altimeter.stopRelativeAltitudeUpdates()
        state = .notMonitoring
        if #available(iOS 13.0, *) {
            eventsSubject.send(completion: .finished)
        } else {
            // Fallback on earlier versions
        }
    }

}

extension CMAltimeter {

    fileprivate static var availability: SourceAvailability {
        guard isRelativeAltitudeAvailable() else {
            return .unavailable
        }

        let authorizationStatus = self.authorizationStatus()
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
