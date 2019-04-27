import UIKit
import Quick
import Nimble

@testable
import GatheredKit

final class PropertyTests: QuickSpec {

    override func spec() {
        describe("Property") {
            var property: Property<String, Formatter>!
            
            beforeEach {
                property = Property(displayName: "Test Value", value: "Test")
            }
                
            context("valueAsAny") {
                it("should be castable to String") {
                    expect(property.valueAsAny as? String).toNot(beNil())
                }
                
                it("should be a String") {
                    expect(property.valueAsAny).to(beAnInstanceOf(String.self))
                }
            }
        }
    }

}
