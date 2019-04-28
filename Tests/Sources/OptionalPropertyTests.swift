import UIKit
import Quick
import Nimble

@testable
import GatheredKit

final class OptionalPropertyTests: QuickSpec {

    override func spec() {
        describe("OptionalProperty") {
            var value: OptionalProperty<String, Formatter>!
            
            beforeEach {
                value = OptionalProperty(displayName: "Test Value")
            }
            
            context("with a nil value") {
                context("valueAsAny") {
                    it("should be nil") {
                        expect(value.valueAsAny == nil).to(beTrue())
                    }

                    it("should not be castable to String") {
                        expect(value.valueAsAny as? String).to(beNil())
                    }
                    
                    it("should be a String?") {
                        expect(value.valueAsAny is String?).to(beTrue())
                    }
                }
            }
            
            context("with a non-nil value") {
                beforeEach {
                    value.update(value: "test")
                }
                
                context("valueAsAny") {
                    it("should not be nil") {
                        expect(value.valueAsAny).toNot(beNil())
                    }
                    
                    it("should be castable to String") {
                        expect(value.valueAsAny as? String).toNot(beNil())
                    }
                    
                    it("should be a String?") {
                        expect(value.valueAsAny is String?).to(beTrue())
                    }
                }
            }
            
            context("when cast to an AnyProperty") {
                var anyValue: AnyProperty!
                
                beforeEach {
                    anyValue = value as AnyProperty
                }
                
                context("with a nil value") {
                    context("value") {
                        it("should be nil") {
                            expect(anyValue.value).to(beNil())
                        }
                        
                        it("should equal nil") {
                            expect(anyValue.value == nil).to(beTrue())
                        }
                        
                        it("should not be castable to String") {
                            expect(anyValue.value as? String).to(beNil())
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
                        
                        it("should equal 'test'") {
                            expect((anyValue.value as! String)).to(equal("test"))
                        }
                        
                        it("should be castable to String") {
                            expect(anyValue.value as? String).toNot(beNil())
                        }
                        
                        it("should be a String?") {
                            expect(anyValue.value is String?).to(beTrue())
                        }
                    }
                }
            }
        }
    }

}
