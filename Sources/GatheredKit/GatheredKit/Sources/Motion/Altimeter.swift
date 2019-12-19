#if os(iOS) || os(watchOS)
import Foundation
import CoreMotion
import Combine

public final class Altimeter: Controllable, ActionProvider {

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
        }
    }

    public let publisher = Publisher()

    public var isUpdating: Bool {
        switch state {
        case .monitoring:
            return true
        case .notMonitoring:
            return false
        }
    }

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

    private var state: State = .notMonitoring

    private var propertyUpdateCancellables: [AnyCancellable] = []

    public init() {
        propertyUpdateCancellables = publishUpdateWhenAnyPropertyUpdates()
    }

    public func startUpdating() {
        let updatesQueue = OperationQueue(name: "GatheredKit Altimeter Updates")
        let altimeter = CMAltimeter()

        altimeter.startRelativeAltitudeUpdates(to: updatesQueue) { [weak self] data, error in
            guard let self = self else { return }
            guard let data = data else { return }
            self.relativeAltitude.update(value: data.relativeAltitude)
            self.pressure.update(value: data.pressure)
        }

        state = .monitoring(altimeter: altimeter, updatesQueue: updatesQueue)
    }

    public func stopUpdating() {
        guard .monitoring(let altimeter, _) = state else { return }
        altimeter.stopRelativeAltitudeUpdates()
        state = .notMonitoring
    }

}
#endif
