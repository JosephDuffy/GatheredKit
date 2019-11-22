import Foundation
import Quick
import Nimble
import GatheredKit

final class OptionalMeasurementPropertyTests: QuickSpec {

    override func spec() {
        describe("OptionalMeasurementProperty") {
            var property: OptionalMeasurementProperty<UnitFrequency>!
            
            context("with a nil value") {
                beforeEach {
                    property = OptionalMeasurementProperty(displayName: "Test", value: nil)
                }
                
                context("formattedValue") {
                    it("should be nil") {
                        expect(property.formattedValue).to(beNil())
                    }
                }
            }
            
            context("with a non-nil value") {
                beforeEach {
                    property = OptionalMeasurementProperty(displayName: "Test", value: 5)
                }
                
                context("value.formatter.string(for:)") {
                    context("called with the value") {
                        var formatterString: String?
                        
                        beforeEach {
                            formatterString = property.formatter.string(for: property.value)
                        }
                        
                        it("should not return nil") {
                            expect(formatterString).toNot(beNil())
                        }
                    }
                }
            }
        }
    }

}
