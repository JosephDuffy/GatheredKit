//
//  ScreenTests.swift
//  GatheredKitTests
//
//  Created by Joseph Duffy on 07/02/2017.
//  Copyright © 2017 Joseph Duffy. All rights reserved.
//

import Quick
import Nimble

@testable
import GatheredKit

final class ScreenTests: QuickSpec {
    
    override func spec() {
        describe("a screen") {
            var mock: MockScreenBackingData!
            var screen: Screen!

            beforeEach {
                mock = MockScreenBackingData()
                screen = Screen(screen: mock)
            }

            context("that has not had `updateData()` called") {

                it("will load the reported screen resolution from the backing data") {
                    expect(mock.boundsWasCalled).to(beTrue())
                }

                it("will load the reported screen scale from the backing data") {
                    expect(mock.scaleWasCalled).to(beTrue())
                }

                it("will load the native screen resolution from the backing data") {
                    expect(mock.nativeBoundsWasCalled).to(beTrue())
                }

                it("will load the native screen scale from the backing data") {
                    expect(mock.nativeScaleWasCalled).to(beTrue())
                }

                it("will load the brightness from the backing data") {
                    expect(mock.brightnessWasCalled).to(beTrue())
                }

                it("will load the correct value for the reported screen resolution") {
                    expect(screen.reportedScreenResolution.value).toNot(beNil())
                    expect(screen.reportedScreenResolution.value).to(equal(mock.bounds.size))
                }

                it("will load the correct value for the reported screen scale") {
                    expect(screen.reportedScreenScale.value).toNot(beNil())
                    expect(screen.reportedScreenScale.value).to(equal(mock.scale))
                }

                it("will load the correct value for the native screen resolution") {
                    expect(screen.nativeScreenResolution.value).toNot(beNil())
                    expect(screen.nativeScreenResolution.value).to(equal(mock.nativeBounds.size))
                }

                it("will load the correct value for the native screen scale") {
                    expect(screen.nativeScreenScale.value).toNot(beNil())
                    expect(screen.nativeScreenScale.value).to(equal(mock.nativeScale))
                }

                it("will load the correct value for the brightness") {
                    expect(screen.brightness.value).toNot(beNil())
                    expect(screen.brightness.value).to(equal(mock.brightness))
                }
            }

            context("that has had `updateData()` called") {

                beforeEach {
                    screen.updateData()
                }

                it("will load the reported screen resolution from the backing data") {
                    expect(mock.boundsWasCalled).to(beTrue())
                }

                it("will load the reported screen scale from the backing data") {
                    expect(mock.scaleWasCalled).to(beTrue())
                }

                it("will load the native screen resolution from the backing data") {
                    expect(mock.nativeBoundsWasCalled).to(beTrue())
                }

                it("will load the native screen scale from the backing data") {
                    expect(mock.nativeScaleWasCalled).to(beTrue())
                }

                it("will load the brightness from the backing data") {
                    expect(mock.brightnessWasCalled).to(beTrue())
                }

                it("will load the correct value for the reported screen resolution") {
                    expect(screen.reportedScreenResolution.value).toNot(beNil())
                    expect(screen.reportedScreenResolution.value).to(equal(mock.bounds.size))
                }

                it("will load the correct value for the reported screen scale") {
                    expect(screen.reportedScreenScale.value).toNot(beNil())
                    expect(screen.reportedScreenScale.value).to(equal(mock.scale))
                }

                it("will load the correct value for the native screen resolution") {
                    expect(screen.nativeScreenResolution.value).toNot(beNil())
                    expect(screen.nativeScreenResolution.value).to(equal(mock.nativeBounds.size))
                }

                it("will load the correct value for the native screen scale") {
                    expect(screen.nativeScreenScale.value).toNot(beNil())
                    expect(screen.nativeScreenScale.value).to(equal(mock.nativeScale))
                }

                it("will load the correct value for the brightness") {
                    expect(screen.brightness.value).toNot(beNil())
                    expect(screen.brightness.value).to(equal(mock.brightness))
                }
            }
        }
    }
    
}

private class MockScreenBackingData: ScreenBackingData {

    var boundsWasCalled = false
    var scaleWasCalled = false
    var nativeBoundsWasCalled = false
    var nativeScaleWasCalled = false
    var brightnessWasCalled = false

    var bounds: CGRect {
        self.boundsWasCalled = true
        return CGRect(x: 0, y: 0, width: 320, height: 480)
    }

    var scale: CGFloat {
        self.scaleWasCalled = true
        return 2
    }

    var nativeBounds: CGRect {
        self.nativeBoundsWasCalled = true
        return CGRect(x: 0, y: 0, width: 640, height: 960)
    }

    var nativeScale: CGFloat {
        self.nativeScaleWasCalled = true
        return 2
    }

    var brightness: CGFloat {
        self.brightnessWasCalled = true
        return 0.76
    }

    init() {}

}
