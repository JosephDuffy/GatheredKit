#if os(iOS) || os(tvOS)
@testable import GatheredKitScreen
import UIKit

// swift-format-ignore: NoLeadingUnderscores

@MainActor
final class MockScreen: UIScreen {
    static func == (lhs: MockScreen, rhs: UIScreen) -> Bool {
        if lhs.forceEqualToMain, rhs == .main {
            return true
        } else {
            return (lhs as UIScreen) == rhs
        }
    }

    static func == (lhs: UIScreen, rhs: MockScreen) -> Bool {
        if rhs.forceEqualToMain, lhs == .main {
            return true
        } else {
            return (rhs as UIScreen) == lhs
        }
    }

    var forceEqualToMain = false

    override func isEqual(_ object: Any?) -> Bool {
        guard let screen = object as? UIScreen else {
            return super.isEqual(object)
        }

        return MainActor.assumeIsolated {
            if forceEqualToMain, screen.isEqual(UIScreen.main) == true {
                return true
            } else {
                return super.isEqual(screen)
            }
        }
    }

    private var _bounds: CGRect?

    override var bounds: CGRect {
        get {
            _bounds ?? super.bounds
        }
        set {
            _bounds = newValue
        }
    }

    private var _nativeBounds: CGRect?

    override var nativeBounds: CGRect {
        get {
            _nativeBounds ?? super.nativeBounds
        }
        set {
            _nativeBounds = newValue
        }
    }

    private var _scale: CGFloat?

    override var scale: CGFloat {
        get {
            _scale ?? super.scale
        }
        set {
            _scale = newValue
        }
    }

    private var _nativeScale: CGFloat?

    override var nativeScale: CGFloat {
        get {
            _nativeScale ?? super.nativeScale
        }
        set {
            _nativeScale = newValue
        }
    }

    #if os(iOS)
    private var _brightness: CGFloat?

    override var brightness: CGFloat {
        get {
            _brightness ?? super.brightness
        }
        set {
            _brightness = newValue
        }
    }
    #endif
}
#endif
