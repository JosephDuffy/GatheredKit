#if canImport(UIKit)
import UIKit
@testable
import GatheredKit

final class MockScreen: UIScreen {

    private var _bounds: CGRect?

    override var bounds: CGRect {
        get {
            return _bounds ?? super.bounds
        }
        set {
            _bounds = newValue
        }
    }

    private var _nativeBounds: CGRect?

    override var nativeBounds: CGRect {
        get {
            return _nativeBounds ?? super.nativeBounds
        }
        set {
            _nativeBounds = newValue
        }
    }

    private var _scale: CGFloat?

    override var scale: CGFloat {
        get {
            return _scale ?? super.scale
        }
        set {
            _scale = newValue
        }
    }

    private var _nativeScale: CGFloat?

    override var nativeScale: CGFloat {
        get {
            return _nativeScale ?? super.nativeScale
        }
        set {
            _nativeScale = newValue
        }
    }

    private var _brightness: CGFloat?

    override var brightness: CGFloat {
        get {
            return _brightness ?? super.brightness
        }
        set {
            _brightness = newValue
        }
    }

}
#endif
