public struct SourceProviderIdentifier: Codable, Hashable, LosslessStringConvertible, Sendable {
    public struct InstanceIdentifier: Codable, Hashable, LosslessStringConvertible, Sendable {
        /// The character used to indicate the instance identifier is ephemeral.
        public static let ephemeralSuffix: Character = "~"

        /// An identifier to differentiate between instances of the same source
        /// kind.
        public let id: String

        /// When `true` the identifier is unique at the time of creation but is not
        /// guaranteed to be the same between runs of the program or changes in
        /// hardware state, e.g. disconnecting and reconnecting an external display.
        public let isEphemeral: Bool

        /// The string representation in the form:
        ///
        /// <instance-identifier>[~]
        ///
        /// A `~` suffix indicates this is an ephemeral identifier.
        public let description: String

        public init(id: String, isEphemeral: Bool) {
            assert(!id.hasSuffix(String(Self.ephemeralSuffix)), "Instance identifier should not end with `~` to avoid serialisation issues")

            self.id = id
            self.isEphemeral = isEphemeral

            if isEphemeral {
                description = id + String(Self.ephemeralSuffix)
            } else {
                description = id
            }
        }

        public init(_ description: String) {
            if description.hasSuffix(String(Self.ephemeralSuffix)) {
                isEphemeral = true
                id = String(description.dropLast(1))
            } else {
                isEphemeral = false
                id = description
            }

            self.description = description
        }
    }

    /// The character used to separate the namespace and the source kind.
    public static let namespaceSuffix: Character = "."

    /// The character used to separate the source kind and the instance identifier.
    public static let instanceIdentifierPrefix: Character = "/"

    public let namespace: String

    public let sourceKind: SourceKind

    /// An identifier to differentiate between instances of the same source
    /// kind. If all instances of a source are logically equivalent this can be
    /// `nil`.
    ///
    /// For example, the ``Location`` source does not provide an instance
    /// identifier but the ``Camera`` source does.
    public let instanceIdentifier: InstanceIdentifier?

    /// The string representation in the form:
    ///
    /// <namespace>.<source-kind>[/<instance-identifier>]
    public let description: String

    public init(
        namespace: String = SourceIdentifier.gatheredKitNamespace,
        sourceKind: SourceKind,
        instanceIdentifier: InstanceIdentifier? = nil
    ) {
        self.namespace = namespace
        self.sourceKind = sourceKind
        self.instanceIdentifier = instanceIdentifier

        var description = namespace
            + String(Self.namespaceSuffix)
            + sourceKind.rawValue

        if let instanceIdentifier = instanceIdentifier {
            description += String(Self.instanceIdentifierPrefix)
                + String(describing: instanceIdentifier)
        }

        self.description = description
    }

    public init(
        namespace: String = SourceIdentifier.gatheredKitNamespace,
        sourceKind: SourceKind,
        instanceIdentifier id: String,
        isEphemeral: Bool
    ) {
        self.namespace = namespace
        self.sourceKind = sourceKind
        let instanceIdentifier = InstanceIdentifier(id: id, isEphemeral: isEphemeral)
        self.instanceIdentifier = instanceIdentifier
        self.description = namespace
            + String(Self.namespaceSuffix)
            + sourceKind.rawValue
            + String(Self.instanceIdentifierPrefix)
            + String(describing: instanceIdentifier)
    }

    public init?(_ description: String) {
        guard !description.isEmpty else { return nil }

        let instanceSplit = description.split(separator: Self.instanceIdentifierPrefix, maxSplits: 1)

        let kindSplit = instanceSplit[0].split(separator: Self.namespaceSuffix, maxSplits: 1)

        guard kindSplit.count == 2 else { return nil }

        self.namespace = String(kindSplit[0])
        self.sourceKind = SourceKind(String(kindSplit[1]))
        self.description = description

        if instanceSplit.count < 2 {
            instanceIdentifier = nil
        } else {
            instanceIdentifier = InstanceIdentifier(String(instanceSplit[1]))
        }
    }
}
