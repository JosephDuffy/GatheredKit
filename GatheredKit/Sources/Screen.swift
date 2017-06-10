//
//  Screen.swift
//  GatheredKit
//
//  Created by Joseph Duffy on 04/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import UIKit

/**
 A wrapper around `UIScreen`
 */
public final class Screen: AutomaticallyUpdatingSource, ManuallyUpdatableSource {

    private enum State {
        case notMonitoring
        case monitoring(brightnessChangeObeserver: NSObjectProtocol)
    }

    /// A boolean indicating if the source is available on the current device
    public static var isAvailable = true

    /// A user-friendly name for the source
    public static var displayName = "Screen"

    /// A boolean indicating if the screen is monitoring for brightness changes
    public var isUpdating: Bool {
        switch state {
        case .notMonitoring:
            return false
        case .monitoring(_):
            return true
        }
    }

    /// A delegate that will receive messages about the screen's data changing
    public weak var delegate: SourceDelegate?

    /// The `ScreenBackingData` this `Screen` represents
    internal let screen: ScreenBackingData

    /**
     The screen resolution reported by the system

     **Properties**

     Display name: Screen Resolution (reported)

     Unit: Point
     
     Formatted value: "\(width) x \(height)"
     */
    public private(set) var reportedScreenResolution: SourceProperty<CGSize>

    /**
     The native resolution of the screen
 
     **Properties**

     Display name: Screen Resolution (native)

     Unit: Pixel

     Formatted value: "\(width) x \(height)"
    */
    public private(set) var nativeScreenResolution: SourceProperty<CGSize>

    /**
     The natural scale factor associated with the screen
     
     **Properties**

     Display name: Screen Scale (reported)
     */
    public private(set) var reportedScreenScale: SourceProperty<CGFloat>

    /**
     The native scale factor for the physical screen
 
     **Properties**
 
     Display name: Screen Scale (native)
     */
    public private(set) var nativeScreenScale: SourceProperty<CGFloat>

    /**
     The brightness level of the screen. The value of this property will be a number between
     0.0 and 1.0, inclusive

     **Properties**
 
     Display name: Brightness
 
     Unit: Percent
     */
    public private(set) var brightness: SourceProperty<CGFloat>

    /// The internal state, indicating if the screen is monitoring for changes
    private var state: State = .notMonitoring

    /**
     Create a new instance of `Screen` for the given `UIScreen` instance
     
     - parameter screen: The `UIScreen` to get data from
    */
    public required init(screen: ScreenBackingData = UIScreen.main) {
        self.screen = screen
        reportedScreenResolution = SourceProperty(displayName: "Screen Resolution (reported)", value: screen.bounds.size, unit: Point())
        nativeScreenResolution = SourceProperty(displayName: "Screen Resolution (native)", value: screen.nativeBounds.size, unit: Pixel())
        reportedScreenScale = SourceProperty(displayName: "Screen Scale (reported)", value: screen.scale)
        nativeScreenScale = SourceProperty(displayName: "Screen Scale (native)", value: screen.nativeScale)
        brightness = SourceProperty(displayName: "Brightness", value: screen.brightness, unit: Percent())
    }

    deinit {
        stopMonitoring()
    }

    /**
     Start automatically monitoring changes to the source. This will start delegate methods being called
     when new data is available
     */
    public func startMonitoring() {
        guard !isUpdating else { return }

        let brightnessChangeObeserver = NotificationCenter.default.addObserver(forName: .UIScreenBrightnessDidChange, object: screen, queue: .main) { [weak self] _ in
            guard let `self` = self else { return }

            self.brightness.updateData(value: self.screen.brightness)
            self.notifyListenersPropertiesUpdated()
        }

        state = .monitoring(brightnessChangeObeserver: brightnessChangeObeserver)

        updateProperties()
        notifyListenersPropertiesUpdated()
    }

    /**
     Stop performing automatic date refreshes
     */
    public func stopMonitoring() {
        guard case .monitoring(let brightnessChangeObeserver) = state else { return }

        NotificationCenter.default.removeObserver(brightnessChangeObeserver)

        state = .notMonitoring
    }

    /**
     Force the screen to update its properties. Note that there is no guarantee that new data
     will be available
     */
    public func updateProperties() {
        let resolution = screen.bounds.size
        let nativeResolution = screen.nativeBounds.size

        reportedScreenResolution.updateData(value: resolution, formattedValue: formattedString(for: resolution))

        nativeScreenResolution.updateData(value: nativeResolution, formattedValue: formattedString(for: nativeResolution))

        reportedScreenScale.updateData(value: screen.scale)

        nativeScreenScale.updateData(value: screen.nativeScale)

        brightness.updateData(value: screen.brightness)
    }

    /**
     Generates and returns a human-friendly string that represents the given size. String will be in the format:
     
     "\(width) x \(height)"
     
     Numeric values (width and height) will be formatted using a `NumberFormatter`
     
     - parameter size: The size to be formatted
     
     - returns: The formatted string
    */
    internal func formattedString(for size: CGSize) -> String {
        let formatter = NumberFormatter()
        let widthString = formatter.string(from: size.width as NSNumber) ?? "\(size.width)"
        let heightString = formatter.string(from: size.height as NSNumber) ?? "\(size.height)"

        return "\(widthString) x \(heightString)"
    }

}

/**
 The backing data for the `Screen` source. `UIScreen` conforms to this without any changes
 */
public protocol ScreenBackingData {

    /// Bounds of entire screen in points
    var bounds: CGRect { get }

    /// The natural scale factor associated with the screen.
    var scale: CGFloat { get }

    /// Native bounds of the physical screen in pixels
    var nativeBounds: CGRect { get }

    /// Native scale factor of the physical screen
    var nativeScale: CGFloat { get }

    /// 0 ... 1.0, where 1.0 is maximum brightness
    var brightness: CGFloat { get }

}

extension UIScreen: ScreenBackingData {}
