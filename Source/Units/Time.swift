import Foundation

public struct Time: ZeroConfigurationUnit {

    private var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()

    public init() { }

    public func formattedString(for value: TimeInterval) -> String {
        return formatter.string(from: value)
            ?? (value == 1 ? "1 Second" : "\(value) Seconds")
    }

}
