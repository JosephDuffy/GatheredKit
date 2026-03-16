import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
@testable import GatheredKitMacrosMacros

final class SourceKindsMacroTests: XCTestCase {
    private let macros: [String: Macro.Type] = [
        "SourceKind": SourceKindDeclaration.self,
    ]

    func testInferredRawValue() {
        assertMacroExpansion(
            """
            extension SourceKind {
                #SourceKind("camera")
            }
            """,
            expandedSource: """
            extension SourceKind {
                public static let camera: SourceKind = "camera"
            }
            """,
            macros: macros
        )
    }

    func testExplicitRawValueOverride() {
        assertMacroExpansion(
            """
            extension SourceKind {
                #SourceKind("memoryStatistics", rawValue: "memory.statistics")
            }
            """,
            expandedSource: """
            extension SourceKind {
                public static let memoryStatistics: SourceKind = "memory.statistics"
            }
            """,
            macros: macros
        )
    }

    func testInvalidSourceKindExpressionProducesDiagnostic() {
        assertMacroExpansion(
            """
            extension SourceKind {
                #SourceKind(camera)
            }
            """,
            expandedSource: """
            extension SourceKind {
                #SourceKind(camera)
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "#SourceKind sourceKind argument must be a string literal with a valid identifier", line: 2, column: 5),
            ],
            macros: macros
        )
    }

    func testInvalidIdentifierStringProducesDiagnostic() {
        assertMacroExpansion(
            """
            extension SourceKind {
                #SourceKind("not-valid")
            }
            """,
            expandedSource: """
            extension SourceKind {
                #SourceKind("not-valid")
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "#SourceKind sourceKind argument must be a string literal with a valid identifier", line: 2, column: 5),
            ],
            macros: macros
        )
    }

    func testNonStringRawValueProducesDiagnostic() {
        assertMacroExpansion(
            """
            extension SourceKind {
                #SourceKind("camera", rawValue: 123)
            }
            """,
            expandedSource: """
            extension SourceKind {
                #SourceKind("camera", rawValue: 123)
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "#SourceKind rawValue must be a string literal", line: 2, column: 5),
            ],
            macros: macros
        )
    }

    func testInvalidSecondLabelProducesDiagnostic() {
        assertMacroExpansion(
            """
            extension SourceKind {
                #SourceKind("camera", value: "camera")
            }
            """,
            expandedSource: """
            extension SourceKind {
                #SourceKind("camera", value: "camera")
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "#SourceKind second argument label must be 'rawValue'", line: 2, column: 5),
            ],
            macros: macros
        )
    }

    func testTooManyArgumentsProducesDiagnostic() {
        assertMacroExpansion(
            """
            extension SourceKind {
                #SourceKind("camera", rawValue: "camera", "extra")
            }
            """,
            expandedSource: """
            extension SourceKind {
                #SourceKind("camera", rawValue: "camera", "extra")
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "#SourceKind supports one or two arguments", line: 2, column: 5),
            ],
            macros: macros
        )
    }
}
