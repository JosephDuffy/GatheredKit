import Foundation
import Danger

func checkSwiftVersions() {
    var swiftVersions: [String] = []

    let projectPath = "./GatheredKit.xcodeproj/project.pbxproj"
    if let data = FileManager.default.contents(atPath: projectPath) {
        guard let content = String(data: data, encoding: .utf8) else {
            warn("Could not decode data at " + projectPath + " as UTF8")
            return
        }

        do {
            let regex = try NSRegularExpression(pattern: "SWIFT_VERSION = (.*);", options: [])
            let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
            swiftVersions += matches.flatMap { match in
                return (0..<match.numberOfRanges).map { rangeIndex in
                    let range = match.range(at: rangeIndex)
                    let startIndex = content.index(content.startIndex, offsetBy: range.location)
                    let indexPastEnd = content.index(content.startIndex, offsetBy: range.location + range.length)
                    return String(content[startIndex..<indexPastEnd])
                }
            }
        } catch {
            warn("Error creating swift version check regex: \(error.localizedDescription)")
        }
    } else {
        warn("Unable to find project file at " + projectPath)
    }

    let swiftVersionPath = ".swift-version"
    if let data = FileManager.default.contents(atPath: swiftVersionPath) {
        guard let content = String(data: data, encoding: .utf8) else {
            warn("Could not decode data at " + swiftVersionPath + " as UTF8")
            return
        }
        swiftVersions.append(content)
    } else {
        warn("Unable to find swift version file at " + swiftVersionPath)
    }

    let uniqueVersions = Set(swiftVersions)
    if uniqueVersions.isEmpty {
        warn("Found no swift versions")
    } else if uniqueVersions.count > 1 {
        fail("Found mismatch swift versions: \(uniqueVersions)")
    }
}

checkSwiftVersions()
