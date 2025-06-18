import Algorithms
import SwiftSyntax
import SwiftSyntaxMacros

import SwiftCompilerPlugin

@main
struct GatheredKitMacros: CompilerPlugin {
    var providingMacros: [Macro.Type] = [UpdatableProperty.self, ChildPropertyMeasurement.self]
}

public struct UpdatableProperty: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let childPropertyCandidates = declaration.memberBlock.members
            .compactMap { $0.decl.as(VariableDeclSyntax.self) }
            .filter(ChildPropertyMeasurement.isSupportedOnVariable(_:))

        guard let valueType = (
            node.attributeName.as(IdentifierTypeSyntax.self)
        )?.genericArgumentClause?.arguments.first?.argument.trimmed else {
            fatalError("Expected a generic argument for UpdatableProperty macro")
        }

        let wrappedValueProperty: DeclSyntax = """
            public var wrappedValue: \(valueType) {
                get {
                    snapshot.value
                }
                set {
                    updateValue(newValue)
                }
            }
        """

        let idProperty: DeclSyntax = """
            public let id: PropertyIdentifier
        """

        let allPropertiesProperty: DeclSyntax = """
            public var allProperties: [any Property] {
                [
                    \(raw: childPropertyCandidates.map { "$\($0.bindings.first!.pattern)" }.joined(separator: ",\n")),
                ]
            }
        """

        let projectedValueProperty: DeclSyntax = """
            public var projectedValue: some Property<\(valueType)> {
                asReadOnlyProperty
            }
        """

        let snapshotProperty: DeclSyntax = """
            @Published
            public internal(set) var snapshot: Snapshot<\(valueType)>
        """

        let snapshotsPublisherProperty: DeclSyntax = """
            public var snapshotsPublisher: AnyPublisher<Snapshot<\(valueType)>, Never> {
                $snapshot.eraseToAnyPublisher()
            }
        """

        var initialiser: InitializerDeclSyntax!

        if
            valueType.is(OptionalTypeSyntax.self) ||
            valueType.is(ImplicitlyUnwrappedOptionalTypeSyntax.self) ||
            valueType.as(IdentifierTypeSyntax.self)?.name.trimmed == "Optional"
        {
            initialiser = ("""
            public init(
                id: PropertyIdentifier,
                value: \(valueType) = nil,
                date: Date = Date()
            ) {
                self.id = id
                snapshot = Snapshot(value: value, date: date)
            }
            """ as DeclSyntax).as(InitializerDeclSyntax.self)!
        } else {
            initialiser = ("""
            public init(
                id: PropertyIdentifier,
                value: \(valueType),
                date: Date = Date()
            ) {
                self.id = id
                snapshot = Snapshot(value: value, date: date)
            }
            """ as DeclSyntax).as(InitializerDeclSyntax.self)!
        }


        if var body = initialiser.body {
            for childPropertyCandidate in childPropertyCandidates {
                do {
                    let propertyInit = try propertyInit(for: childPropertyCandidate)
                    let codeBlock = CodeBlockItemSyntax(item: .expr(propertyInit))
                    body.statements.insert(codeBlock, at: body.statements.indices.startIndex)
                } catch {
                    print(error)
                }
            }

            initialiser.body = body
        }

        var updateValueFunction = ("""
            @discardableResult
            public func updateValue(_ value: \(valueType), date: Date = Date()) -> Snapshot<\(valueType)> {
                snapshot.updateValue(value, date: date)
                return snapshot
            }
        """ as DeclSyntax).as(FunctionDeclSyntax.self)!

        if var body = updateValueFunction.body {
            for childPropertyCandidate in childPropertyCandidates {
                do {
                    let propertyValueUpdate = try propertyValueUpdate(for: childPropertyCandidate)
                    let codeBlock = CodeBlockItemSyntax(item: .expr(propertyValueUpdate))
                    body.statements.insert(codeBlock, at: body.statements.indices.startIndex)
                } catch {
                    print(error)
                }
            }

            updateValueFunction.body = body
        }

        // TODO: Generate `_` and `$` properties for each child property

        var declarations: [DeclSyntax] = [
            wrappedValueProperty,
            idProperty,
            allPropertiesProperty,
            projectedValueProperty,
            snapshotProperty,
            snapshotsPublisherProperty,
            DeclSyntax(initialiser),
            DeclSyntax(updateValueFunction),
        ]

        for childPropertyCandidate in childPropertyCandidates {
            do {
                let storageAndAccess = try storageAndAccess(for: childPropertyCandidate)
                declarations.append(contentsOf: storageAndAccess)
            } catch {
                print(error)
            }
        }

        return declarations
    }

    private static func propertyInit(for variable: VariableDeclSyntax) throws -> ExprSyntax {
        guard let binding = variable.bindings.first else {
            fatalError()
        }
        guard let typeAnnotation = binding.typeAnnotation else {
            fatalError()
        }

        func attribute(named macroName: String) -> AttributeSyntax? {
            for attribute in variable.attributes {
                guard let attribute = attribute.as(AttributeSyntax.self) else { continue }
                let identifier = attribute
                    .attributeName
                    .as(IdentifierTypeSyntax.self)
                if identifier?.name.tokenKind == .identifier(macroName) {
                    return attribute
                }
            }

            return nil
        }

        guard let attribute = attribute(named: "ChildProperty") else {
            return ""
        }

        var unit: MemberAccessExprSyntax?

        if let arguments = attribute.arguments?.as(LabeledExprListSyntax.self) {
            for argument in arguments {
                guard let label = argument.label else { continue }
                switch label.trimmed.text {
                case "unit":
                    guard let expression = argument.expression.as(MemberAccessExprSyntax.self) else {
                        continue
                    }
                    unit = expression
                default:
                    break
                }
            }
        }

        guard let unit else {
            fatalError("Unit must be provided")
        }

        if
            typeAnnotation.type.is(OptionalTypeSyntax.self) ||
            typeAnnotation.type.is(ImplicitlyUnwrappedOptionalTypeSyntax.self) ||
            typeAnnotation.type.as(IdentifierTypeSyntax.self)?.name.trimmed == "Optional"
        {
            return """
            _\(binding.pattern) = OptionalMeasurementProperty(
                id: id.childIdentifierForPropertyId("\(binding.pattern)"),
                unit: \(unit),
                value: value?.\(binding.pattern),
                date: date
            )
            """
        } else {
            return """
            _\(binding.pattern) = MeasurementProperty(
                id: id.childIdentifierForPropertyId("\(binding.pattern)"),
                value: value.\(binding.pattern),
                unit: \(unit),
                date: date
            )
            """
        }
    }

    private static func storageAndAccess(for variable: VariableDeclSyntax) throws -> [DeclSyntax] {
        guard let binding = variable.bindings.first else {
            fatalError()
        }
        guard let typeAnnotation = binding.typeAnnotation else {
            fatalError()
        }

        func unitForMeasurement(type: TypeSyntax) throws -> TypeSyntax {
            guard let identifierType = type.as(IdentifierTypeSyntax.self) else {
                fatalError()
            }
            guard let genericArgument = identifierType.genericArgumentClause?.arguments.first else {
                fatalError()
            }
            return genericArgument.argument
        }

        if let optionalType = typeAnnotation.type.as(OptionalTypeSyntax.self) {
            let unit = try unitForMeasurement(type: optionalType.wrappedType)
            return [
                """
                private let _\(binding.pattern): OptionalMeasurementProperty<\(unit)>
                """,
                """
                public var $\(binding.pattern): some Property<Measurement<\(unit)>?> {
                    _\(binding.pattern).projectedValue
                }
                """,
            ]
        } else if let optionalType = typeAnnotation.type.as(ImplicitlyUnwrappedOptionalTypeSyntax.self) {
            let unit = try unitForMeasurement(type: optionalType.wrappedType)
            return [
                """
                private let _\(binding.pattern): OptionalMeasurementProperty<\(unit)>
                """,
                """
                public var $\(binding.pattern): some Property<Measurement<\(unit)>?> {
                    _\(binding.pattern).projectedValue
                }
                """,
            ]
        } else if
            let identifierType = typeAnnotation.type.as(IdentifierTypeSyntax.self),
            identifierType.name.trimmed == "Optional",
            let genericType = identifierType.genericArgumentClause?.arguments.first
        {
            let unit = try unitForMeasurement(type: genericType.argument)
            return [
                """
                private let _\(binding.pattern): OptionalMeasurementProperty<\(unit)>
                """,
                """
                public var $\(binding.pattern): some Property<Measurement<\(unit)>?> {
                    _\(binding.pattern).projectedValue
                }
                """,
            ]
        } else {
            let unit = try unitForMeasurement(type: typeAnnotation.type)
            return [
                """
                private let _\(binding.pattern): MeasurementProperty<\(unit)>
                """,
                """
                public var $\(binding.pattern): some Property<Measurement<\(unit)>> {
                    _\(binding.pattern).projectedValue
                }
                """,
            ]
        }
    }

    private static func propertyValueUpdate(for variable: VariableDeclSyntax) throws -> ExprSyntax {
        guard let binding = variable.bindings.first else {
            fatalError()
        }
        guard let typeAnnotation = binding.typeAnnotation else {
            fatalError()
        }

        if
            typeAnnotation.type.is(OptionalTypeSyntax.self) ||
            typeAnnotation.type.is(ImplicitlyUnwrappedOptionalTypeSyntax.self) ||
            typeAnnotation.type.as(IdentifierTypeSyntax.self)?.name.trimmed == "Optional"
        {
            return "_\(binding.pattern).updateMeasuredValue(value?.\(binding.pattern))"
        } else {
            return "_\(binding.pattern).updateMeasuredValue(value.\(binding.pattern))"
        }
    }
}

public struct ChildPropertyMeasurement: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let variable = declaration.as(VariableDeclSyntax.self) else {
//            let fixIt = FixIt(
//                message: HashableMacroFixItMessage(
//                    id: "hashed-added-to-unsupported-node",
//                    message: "Remove @Hashed"
//                ),
//                changes: [
//                    FixIt.Change.replace(
//                        oldNode: Syntax(node),
//                        newNode: Syntax("" as DeclSyntax)
//                    )
//                ]
//            )
//            let diagnostic = Diagnostic(
//                node: Syntax(node),
//                message: HashableMacroDiagnosticMessage(
//                    id: "hashed-added-to-unsupported-node",
//                    message: "The @Hashed macro is only supported on properties.",
//                    severity: .warning
//                ),
//                fixIt: fixIt
//            )
//            context.diagnose(diagnostic)
            return []
        }

        if !isSupportedOnVariable(variable) {
//            let fixIt = FixIt(
//                message: HashableMacroFixItMessage(
//                    id: "hashed-added-to-unsupported-variable",
//                    message: "Remove @Hashed"
//                ),
//                changes: [
//                    FixIt.Change.replace(
//                        oldNode: Syntax(node),
//                        newNode: Syntax("" as DeclSyntax)
//                    )
//                ]
//            )
//            let diagnostic = Diagnostic(
//                node: Syntax(node),
//                message: HashableMacroDiagnosticMessage(
//                    id: "hashed-added-to-unsupported-variable",
//                    message: "The @Hashed macro is only supported on instance properties.",
//                    severity: .warning
//                ),
//                fixIt: fixIt
//            )
//            context.diagnose(diagnostic)
        }

        // Only used to decorate members
        return []
    }

    public static func isSupportedOnVariable(_ variable: VariableDeclSyntax) -> Bool {
        variable.modifiers.allSatisfy { modifier in
            let tokenKind = modifier.name.trimmed.tokenKind
            return tokenKind != .keyword(.static) && tokenKind != .keyword(.class)
        }
    }
}
