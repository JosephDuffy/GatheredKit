import Foundation
import CoreMotion

public final class Altimeter: BaseSource, Source, Controllable, ValuesProvider, ActionProvider {

    private enum State {
        case notMonitoring
        case monitoring(updatesQueue: OperationQueue)
    }

    public static var availability: SourceAvailability {
        return CMAltimeter.isRelativeAltitudeAvailable() ? .available : .unavailable
    }

    public static var name = "Altimeter"

    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    public private(set) var relativeAltitude: GenericValue<NSNumber?, Meter>
    public private(set) var pressure: GenericValue<NSNumber?, Kilopascal>

    public var allValues: [Value] {
        return [
            relativeAltitude,
            pressure,
        ]
    }

    public var actions: [Action] {
        return [
            Action(title: "Reset Altitude", isAvailable: isUpdating, perform: { [weak self] in
                guard let `self` = self else { return }
                self.resetRelativeAltitude()
            })
        ]
    }

    private var state: State = .notMonitoring

    private lazy var altimeter = CMAltimeter()

    public override init() {
        relativeAltitude = GenericValue(displayName: "Relative Altitude")
        pressure = GenericValue(displayName: "Pressure")
    }

    deinit {
        stopUpdating()
    }

    public func resetRelativeAltitude() {
        guard case .monitoring(let updatesQueue) = state else { return }

        altimeter.stopRelativeAltitudeUpdates()
        altimeter.startRelativeAltitudeUpdates(to: updatesQueue, withHandler: updatesHandler(data:error:))
    }

    public func startUpdating() {
        let updatesQueue = OperationQueue()
        updatesQueue.name = "uk.co.josephduffy.GatheredKit Altimeter Updates"

        altimeter.startRelativeAltitudeUpdates(to: updatesQueue, withHandler: updatesHandler(data:error:))

        state = .monitoring(updatesQueue: updatesQueue)
    }

    public func stopUpdating() {
        guard case .monitoring = state else { return }

        altimeter.stopRelativeAltitudeUpdates()

        state = .notMonitoring
    }

    private func updatesHandler(data: CMAltitudeData?, error: Error?) {
        if let error = error {
            print("Error with altimeter data \(error)")
            stopUpdating()
        } else if let data = data {
            relativeAltitude.update(backingValue: data.relativeAltitude)
            pressure.update(backingValue: data.pressure)

            notifyListenersPropertyValuesUpdated()
        }
    }

}
