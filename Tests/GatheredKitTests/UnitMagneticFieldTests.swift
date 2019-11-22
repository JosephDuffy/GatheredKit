import Foundation
import Quick
import Nimble

@testable
import GatheredKit

final class UnitMagneticFieldTests: QuickSpec {

    override func spec() {
        describe("UnitMagneticField") {
            context("microTesla") {
                var microTesla: UnitMagneticField!

                beforeEach {
                    microTesla = .microTesla
                }

                it("should convert 1000 tesla to 1 micro tesla") {
                    expect(microTesla.converter.baseUnitValue(fromValue: 1000)).to(equal(1))
                }

            }
        }
    }

}
