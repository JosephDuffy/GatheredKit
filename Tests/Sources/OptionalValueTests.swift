import UIKit
import Quick
import Nimble

@testable
import GatheredKit

final class OptionalValueTests: QuickSpec {

    override func spec() {
        describe("OptionalValue") {
            var value: OptionalValue<String, Formatter>!
            
            beforeEach {
                value = OptionalValue(displayName: "Test Value")
            }
            
            context("with a nil value") {
                context("backingValueAsAny") {
                    it("should be nil") {
                        expect(value.backingValueAsAny == nil).to(beTrue())
                    }

                    it("should not be castable to String") {
                        expect(value.backingValueAsAny as? String).to(beNil())
                    }
                    
                    it("should be a String?") {
                        expect(value.backingValueAsAny is String?).to(beTrue())
                    }
                }
            }
            
            context("with a non-nil value") {
                beforeEach {
                    value.update(backingValue: "test")
                }
                
                context("backingValueAsAny") {
                    it("should not be nil") {
                        expect(value.backingValueAsAny).toNot(beNil())
                    }
                    
                    it("should be castable to String") {
                        expect(value.backingValueAsAny as? String).toNot(beNil())
                    }
                    
                    it("should be a String?") {
                        expect(value.backingValueAsAny is String?).to(beTrue())
                    }
                }
            }
            
            context("when cast to an AnyValue") {
                var anyValue: AnyValue!
                
                beforeEach {
                    anyValue = value as AnyValue
                }
                
                context("with a nil value") {
                    context("backingValueAsAny") {
                        it("should be nil") {
                            expect(anyValue.backingValueAsAny == nil).to(beTrue())
                        }
                        
                        it("should not be castable to String") {
                            expect(anyValue.backingValueAsAny as? String).to(beNil())
                        }
                        
                        it("should be a String?") {
                            expect(anyValue.backingValueAsAny is String?).to(beTrue())
                        }
                    }
                }
                
                context("with the value 'test'") {
                    beforeEach {
                        value.update(backingValue: "test")
                    }
                    
                    context("backingValueAsAny") {
                        it("should not be nil") {
                            expect(anyValue.backingValueAsAny).toNot(beNil())
                        }
                        
                        it("should equal 'test'") {
                            expect((anyValue.backingValueAsAny as! String)).to(equal("test"))
                        }
                        
                        it("should be castable to String") {
                            expect(anyValue.backingValueAsAny as? String).toNot(beNil())
                        }
                        
                        it("should be a String?") {
                            expect(anyValue.backingValueAsAny is String?).to(beTrue())
                        }
                    }
                }
            }
        }
    }

}
