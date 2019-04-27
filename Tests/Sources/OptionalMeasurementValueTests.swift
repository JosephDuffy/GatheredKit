import UIKit
import Quick
import Nimble

@testable
import GatheredKit

final class OptionalMeasurementValueTests: QuickSpec {

    override func spec() {
        describe("OptionalMeasurementValue") {
            var value: OptionalMeasurementProperty<UnitFrequency>!
            
            beforeEach {
                value = .radiansPerSecond(displayName: "test")
            }
            
            context("with a nil value") {
                context("formattedValue") {
                    it("should be nil") {
                        expect(value.formattedValue).to(beNil())
                    }
                }
            }
            
            context("with a non-nil value") {
                beforeEach {
                    value.update(value: 5, unit: .radiansPerSecond)
                }
                
                context("formattedValue") {
                    it("should not be nil") {
                        expect(value.formattedValue).toNot(beNil())
                    }
                }
            }
        }
    }

}
