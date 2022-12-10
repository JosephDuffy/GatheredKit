import Foundation

public struct ResolutionMeasurement: Codable, Hashable {
    public enum CodingKeys: CodingKey {
        case size
        case unit
    }

    public var size: CGSize

    public var width: Measurement<UnitResolution> {
        Measurement(value: size.width, unit: unit)
    }

    public var height: Measurement<UnitResolution> {
        Measurement(value: size.height, unit: unit)
    }

    public let unit: UnitResolution

    public init(size: CGSize, unit: UnitResolution) {
        self.size = size
        self.unit = unit
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        size = try container.decode(CGSize.self, forKey: .size)
        let unitData = try container.decode(Data.self, forKey: .unit)
        do {
            if let unit = try NSKeyedUnarchiver.unarchivedObject(ofClass: UnitResolution.self, from: unitData) {
                self.unit = unit
            } else {
                throw DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [CodingKeys.unit],
                        debugDescription: "Failed to unarchive UnitResolution from data"
                    )
                )
            }
        } catch let error as DecodingError {
            throw error
        } catch {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(
                    codingPath: [CodingKeys.unit],
                    debugDescription: "Failed to unarchive UnitResolution from data",
                    underlyingError: error
                )
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(size, forKey: .size)
        let unitData = try NSKeyedArchiver.archivedData(withRootObject: unit, requiringSecureCoding: true)
        try container.encode(unitData, forKey: .unit)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(size.width)
        hasher.combine(size.height)
        hasher.combine(unit)
    }
}
