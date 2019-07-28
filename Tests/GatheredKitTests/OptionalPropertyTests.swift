import UIKit
import Quick
import Nimble
import GatheredKit

final class OptionalPropertyTests: QuickSpec {

    override func spec() {
        describe("OptionalProperty") {
            var value: OptionalProperty<String, Formatter>!
            
            beforeEach {
                value = OptionalProperty(displayName: "Test Value")
            }
            
            context("when cast to an AnyProperty") {
                var anyValue: AnyProperty!
                
                beforeEach {
                    anyValue = value as AnyProperty
                }
                
                context("with a nil value") {
                    beforeEach {
                        value.value = nil
                    }

                    context("value") {
                        it("should be nil") {
                            expect(anyValue.value).to(beNil())
                        }
                        
                        it("should equal nil") {
                            expect(anyValue.value == nil).to(beTrue())
                        }
                        
                        it("should not be a String") {
                            expect(anyValue.value is String).to(beFalse())
                        }
                        
                        it("should be a String?") {
                            expect(anyValue.value is String?).to(beTrue())
                        }
                    }
                }
                
                context("with the value 'test'") {
                    beforeEach {
                        value.update(value: "test")
                    }
                    
                    context("value") {
                        it("should not be nil") {
                            expect(anyValue.value).toNot(beNil())
                        }
                        
                        it("should not equal nil") {
                            expect(anyValue.value != nil).to(beTrue())
                        }
                        
                        it("should be a String") {
                            expect(anyValue.value is String).to(beTrue())
                        }
                        
                        it("should be castable to String") {
                            expect(anyValue.value as? String).toNot(beNil())
                        }
                        
                        it("should be a String?") {
                            expect(anyValue.value is String?).to(beTrue())
                        }
                        
                        it(#"should equal "test"#) {
                            expect((anyValue.value as! String)).to(equal("test"))
                        }
                        
                        context("after being unwrapped") {
                            var unwrapped: Any = ""
                            
                            beforeEach {
                                if let value = anyValue.value {
                                    unwrapped = value
                                } else {
                                    expect(false).to(beTrue())
                                }
                            }
                            
                            context("a string describing the unwrapped value") {
                                var stringDescribingUnwrapped = ""
                                
                                beforeEach {
                                    stringDescribingUnwrapped = String(describing: unwrapped)
                                }
                                
                                it(#"should equal "test"#) {
                                    expect(stringDescribingUnwrapped).to(equal("test"))
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
