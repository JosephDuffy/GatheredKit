import UIKit
import Quick
import Nimble

@testable
import GatheredKit

final class ValueTests: QuickSpec {

    override func spec() {
        describe("Value") {
            var value: Value<String, Formatter>!
            
            beforeEach {
                value = Value(displayName: "Test Value", backingValue: "Test")
            }
                
            context("backingValueAsAny") {
                it("should be castable to String") {
                    expect(value.backingValueAsAny as? String).toNot(beNil())
                }
                
                it("should be a String") {
                    expect(value.backingValueAsAny).to(beAnInstanceOf(String.self))
                }
            }
        }
    }

}
