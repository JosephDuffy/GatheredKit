#if os(macOS)
import AppKit
import Combine

/**
 A wrapper around `NSScreen`.
 */
public final class Screen: Source, Controllable {

    public typealias Publisher = PassthroughSubject<[AnyProperty], Never>

    private enum State {
        case notMonitoring
        case monitoring(screenParametersObserver: NSObjectProtocol, colorSpaceObserver: NSObjectProtocol, updatesQueue: OperationQueue)
    }

    public static var availability: SourceAvailability = .available

    public static var name = "Screen"

    public let publisher: Publisher

    /// A boolean indicating if the screen is monitoring for brightness changes
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring:
            return true
        }
    }

    /// The `NSScreen` this `Screen` represents.
    public let nsScreen: NSScreen

    /**
     The resolution of the screen
     */
    public let resolution: SizeValue

    /**
     An array of the screen's properties, in the following order:
     - Resolution
     */
    public var allProperties: [AnyProperty] {
        return [
            resolution,
        ]
    }

    private var propertyUpdateCancellables: [AnyCancellable] = []

    /// The internal state, indicating if the screen is monitoring for changes
    private var state: State = .notMonitoring

    private let notificationCenter: NotificationCenter

    /**
    Create a new instance of `Screen` for the `main` `UIScreen`.
    */
    public convenience init?() {
        guard let screen = NSScreen.main else { return nil }
        self.init(screen: screen)
    }

    /**
     Create a new instance of `Screen` for the given `NSScreen` instance

     - Parameter screen: The `NSScreen` to get data from.
     - Parameter notificationCenter: The notification center to listen to notifications from.
     */
    internal init(screen: NSScreen, notificationCenter: NotificationCenter = .default) {
        self.nsScreen = screen
        self.notificationCenter = notificationCenter

        resolution = SizeValue(
            displayName: "Resolution",
            value: screen.frame.size
        )
        resolution.formatter.suffix = " Pixels"

        publisher = .init()

        propertyUpdateCancellables = allProperties.map { property in
            property.typeErasedPublisher.sink { _ in
                self.publisher.send(self.allProperties)
            }
        }
    }

    deinit {
        stopUpdating()
    }

    /**
     Start automatically monitoring changes to the source. This will start delegate methods being called
     when new data is available
     */
    public func startUpdating() {
        guard !isUpdating else { return }

        let updatesQueue = OperationQueue()
        updatesQueue.name = "uk.co.josephduffy.GatheredKit Screen Updates"

        let screenParametersObserver = notificationCenter.addObserver(forName: NSApplication.didChangeScreenParametersNotification, object: NSApplication.shared, queue: updatesQueue) { [weak self] _ in
            guard let self = self else { return }
            self.resolution.updateValueIfDifferent(self.nsScreen.frame.size)
        }
        resolution.updateValueIfDifferent(nsScreen.frame.size)

        let colorSpaceObserver = notificationCenter.addObserver(forName: NSScreen.colorSpaceDidChangeNotification, object: nsScreen, queue: updatesQueue) { _ in
            // TODO: Update colour space
        }

        state = .monitoring(
            screenParametersObserver: screenParametersObserver,
            colorSpaceObserver: colorSpaceObserver,
            updatesQueue: updatesQueue
        )
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopUpdating() {
        guard case .monitoring(let screenParametersObserver, let colorSpaceObserver, _) = state else { return }

        notificationCenter
            .removeObserver(
                screenParametersObserver,
                name: NSApplication.didChangeScreenParametersNotification,
                object: NSApplication.shared
            )

        notificationCenter
            .removeObserver(
                colorSpaceObserver,
                name: NSScreen.colorSpaceDidChangeNotification,
                object: nsScreen
            )

        state = .notMonitoring
    }

}

#endif