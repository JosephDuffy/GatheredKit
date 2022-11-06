public struct SourceIdentifier: Codable, Hashable, LosslessStringConvertible, Sendable {
    public struct InstanceIdentifier: Codable, Hashable, LosslessStringConvertible, Sendable {
        /// An identifier to differentiate between instances of the same source
        /// kind.
        public let id: String

        /// When `true` the identifier is unique at the time of creation but is not
        /// guaranteed to be the same between runs of the program or changes in
        /// hardware state, e.g. disconnecting and reconnecting an external display.
        public let isTransient: Bool

        /// The string representation in the form:
        ///
        /// <instance-identifier>[~]
        ///
        /// A `~` suffix indicates this is a transient identifier.
        public let description: String

        public init(id: String, isTransient: Bool) {
            assert(!id.hasSuffix("~"), "Instance identifier should not end with `~` to avoid serialisation issues")

            self.id = id
            self.isTransient = isTransient

            if isTransient {
                description = id + "~"
            } else {
                description = id
            }
        }

        public init(_ description: String) {
            if description.hasSuffix("~") {
                isTransient = true
                id = String(description.dropLast(1))
            } else {
                isTransient = false
                id = description
            }

            self.description = description
        }
    }

    /// The character used to separate the namespace and the source kind.
    public static let namespaceSuffix: Character = "."

    /// The character used to separate the device identifier and the source
    /// identifier.
    public static let deviceIdentifierPrefix: Character = "@"

    /// The character used to separate the source kind and the instance identifier.
    public static let instanceIdentifierPrefix: Character = "|"

    public let namespace: String

    public let sourceKind: SourceKind

    /// An identifier to differentiate between instances of the same source
    /// kind. If all instances of a source are logically equivalent this can be
    /// `nil`.
    ///
    /// For example, the ``Location`` source does not provide an instance
    /// identifier but the ``Camera`` source does.
    public let instanceIdentifier: InstanceIdentifier?

    /// An identifier unique to the device this source originates from.
    ///
    /// When `nil` this source originated from the local device.
    public let deviceIdentifier: String?

    /// The string representation in the form:
    ///
    /// <namespace>.<source-kind>[|<instance-identifier>][@<device-identifier>]
    public let description: String

    public init(
        namespace: String = "GatheredKit",
        sourceKind: SourceKind,
        instanceIdentifier: InstanceIdentifier? = nil,
        deviceIdentifier: String? = nil
    ) {
        self.namespace = namespace
        self.sourceKind = sourceKind
        self.instanceIdentifier = instanceIdentifier
        self.deviceIdentifier = deviceIdentifier

        var description = namespace
            + String(Self.namespaceSuffix)
            + sourceKind.rawValue

        if let instanceIdentifier = instanceIdentifier {
            description += String(Self.instanceIdentifierPrefix)
                + String(describing: instanceIdentifier)
        }

        if let deviceIdentifier {
            description += String(Self.deviceIdentifierPrefix)
                + deviceIdentifier
        }

        self.description = description
    }

    public init(
        namespace: String = "GatheredKit",
        sourceKind: SourceKind,
        instanceIdentifier id: String,
        isTransient: Bool,
        deviceIdentifier: String? = nil
    ) {
        self.namespace = namespace
        self.sourceKind = sourceKind
        let instanceIdentifier = InstanceIdentifier(id: id, isTransient: isTransient)
        self.instanceIdentifier = instanceIdentifier
        self.deviceIdentifier = deviceIdentifier

        var description = namespace
            + String(Self.namespaceSuffix)
            + sourceKind.rawValue
            + String(Self.instanceIdentifierPrefix)
            + String(describing: instanceIdentifier)

        if let deviceIdentifier {
            description += String(Self.deviceIdentifierPrefix)
                + deviceIdentifier
        }

        self.description = description
    }

    public init?(_ description: String) {
        guard !description.isEmpty else { return nil }

        let deviceSplit = description.split(separator: Self.deviceIdentifierPrefix, maxSplits: 2)
        let instanceSplit = deviceSplit[0].split(separator: Self.instanceIdentifierPrefix, maxSplits: 2)

        let kindSplit = instanceSplit[0].split(separator: Self.namespaceSuffix, maxSplits: 2)

        guard kindSplit.count == 2 else { return nil }

        self.namespace = String(kindSplit[0])
        self.sourceKind = SourceKind(String(kindSplit[1]))
        self.description = description

        if deviceSplit.count == 2 {
            deviceIdentifier = String(deviceSplit[1])
        } else {
            deviceIdentifier = nil
        }

        if instanceSplit.count == 1 {
            instanceIdentifier = nil
        } else if instanceSplit.count == 2 {
            instanceIdentifier = InstanceIdentifier(String(instanceSplit[1]))
        } else {
            return nil
        }
    }

    public func identifierForChildPropertyWithId(_ propertyId: String) -> PropertyIdentifier {
        PropertyIdentifier(parent: .source(self), id: propertyId)
    }
}
