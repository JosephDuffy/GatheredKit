#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine

public final class Altimeter: Source, Controllable, ActionProvider {

    private enum State {
        case notMonitoring
        case monitoring(altimeter: CMAltimeter, updatesQueue: OperationQueue)
    }

    public static let name = "Altimeter"

    public static var availability: SourceAvailability {
        guard CMAltimeter.isRelativeAltitudeAvailable() else {
            return .unavailable
        }

        let authorizationState = CMAltimeter.authorizationStatus()
        switch authorizationState {
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
    
    public var controllableEventsPublisher: AnyPublisher<ControllableEvent, ControllableError> {
        return eventsSubject.eraseToAnyPublisher()
    }

    private let eventsSubject = PassthroughSubject<ControllableEvent, ControllableError>()

    @Published
    public private(set) var isUpdating: Bool = false

    public let relativeAltitude: OptionalLengthValue = .meters(displayName: "Relative Altitude")
    public let pressure: OptionalPressureValue = .kilopascals(displayName: "Pressire")

    public var allProperties: [AnyProperty] {
        return [relativeAltitude, pressure]
    }

    public var actions: [Action] {
        return [
            Action(title: "Reset Altitude", isAvailable: isUpdating, perform: { [weak self] in
                guard let self = self else { return }
                guard self.isUpdating else { return }
                self.stopUpdating()
                self.startUpdating()
            })
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

    public init() {}

    public func startUpdating() {
        guard !isUpdating else { return }

        let authorizationState = CMAltimeter.authorizationStatus()
        switch authorizationState {
        case .authorized:
            break
        case .denied:
            eventsSubject.send(completion: .failure(.permissionDenied))
            return
        case .notDetermined:
            // Perhaps it will ask the user when `startRelativeAltitudeUpdates` is called?
            break
        case .restricted:
            eventsSubject.send(completion: .failure(.restricted))
            return
        @unknown default:
            eventsSubject.send(completion: .failure(.unknownPermission))
            return
        }
        
        let updatesQueue = OperationQueue(name: "GatheredKit Altimeter Updates")
        let altimeter = CMAltimeter()

        altimeter.startRelativeAltitudeUpdates(to: updatesQueue) { [weak self, weak altimeter] data, error in
            guard let self = self else { return }
            if let error = error {
                altimeter?.stopRelativeAltitudeUpdates()
                self.eventsSubject.send(completion: .failure(.other(error)))
                self.state = .notMonitoring
                return
            }
            guard let data = data else { return }
            self.relativeAltitude.updateValueIfDifferent(data.relativeAltitude.doubleValue)
            self.pressure.updateValueIfDifferent(data.pressure.doubleValue)
        }

        state = .monitoring(altimeter: altimeter, updatesQueue: updatesQueue)
        eventsSubject.send(.startedUpdating)
    }

    public func stopUpdating() {
        guard case .monitoring(let altimeter, _) = state else { return }
        altimeter.stopRelativeAltitudeUpdates()
        state = .notMonitoring
        eventsSubject.send(completion: .finished)
    }

}
#endif
